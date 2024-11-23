import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../events.dart';
import '../../shared/local_storage_keys.dart';
import '../models/bookmark_user_dto.dart';
import '../models/event_model.dart';
import '../repositories/bookmark_event_repository.dart';

class BookmarkEventController extends GetxController {
  final _repository = BookmarkEventRepository();
  RxList<EventModel> bookmarkedEvents = RxList();
  RxList<EventModel> filteredEvents = <EventModel>[].obs;
  var isEventRefreshing = <int, bool>{}.obs;
  RxBool isBookmarked = false.obs;

  // List bookmarkedIds = [];


  var query = ''.obs;
  bool filterFutureEvents = false;
  bool filterWithCapacity = false;
  String? sortOrder;
  double savedMinPrice = 0;
  double savedMaxPrice = 9999;


  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;

  Timer? _debounce;
  void updateSearchQuery(String searchQuery) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      isLoading.value = true;
      query.value = searchQuery;
      getBookmarked();
      // performSearch(searchQuery);
    });
  }



  Future<void> goToEvent(int eventId) async {
    await Get.toNamed(
      RouteNames.detailsEvent,
      parameters: {"eventId": "$eventId"},
    );
  }

  Future<void> filledEvent() async {
    Get.showSnackbar(
      GetSnackBar(
        messageText: const Text(
          "you Can't Buy a Event that is Full or Expired",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        backgroundColor: Colors.redAccent.withOpacity(.2),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> onRefresh() async {
    getBookmarked();
  }



  Future<List<int>> getBookmarkedEvents() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds') ?? [];

    return bookmarkedIds.map((id) => int.parse(id)).toList();
  }

  void showSortAndFilterDialog(
      BuildContext context, {
        required bool initialFilterFutureEvents,
        required bool initialFilterWithCapacity,
        String? initialSortOrder,
        double initialMinPrice = 0,
        double initialMaxPrice = 9999,
      }) {
    RangeValues priceRange = RangeValues(savedMinPrice, savedMaxPrice);

    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Sort and Filter Events"),
              content: isLoading
                  ? const SizedBox(
                height: 80,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Price Range",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: priceRange,
                      min: 0,
                      max: 9999,
                      divisions: 100,
                      labels: RangeLabels(
                        priceRange.start.toStringAsFixed(0),
                        priceRange.end.toStringAsFixed(0),
                      ),
                      onChanged: (values) {
                        setState(() {
                          priceRange = values;
                        });
                      },
                    ),
                    Text(
                      "Min: ${priceRange.start.toStringAsFixed(0)} - Max: ${priceRange.end.toStringAsFixed(0)}",
                    ),
                    CheckboxListTile(
                      title: const Text("Only Future Events"),
                      value: filterFutureEvents,
                      onChanged: (value) {
                        setState(() {
                          filterFutureEvents = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Only Events With Capacity"),
                      value: filterWithCapacity,
                      onChanged: (value) {
                        setState(() {
                          filterWithCapacity = value!;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: sortOrder,
                      hint: const Text("Sort by Time (Optional)"),
                      items: const [
                        DropdownMenuItem(
                          value: "Ascending",
                          child: Text("Ascending (Newest First)"),
                        ),
                        DropdownMenuItem(
                          value: "Descending",
                          child: Text("Descending (Oldest First)"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sortOrder = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: isLoading
                  ? []
                  : [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      priceRange = RangeValues(0, 9999);
                      filterFutureEvents = false;
                      filterWithCapacity = false;
                      sortOrder = null;
                    });
                    getBookmarked();
                    Navigator.pop(context, {
                      'filterFutureEvents': false,
                      'filterWithCapacity': false,
                      'sortOrder': null,
                      'minPrice': 0,
                      'maxPrice': 9999,
                    });
                  },
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await getBookmarked(
                      ascending: sortOrder == "Ascending"
                          ? true
                          : sortOrder == "Descending"
                          ? false
                          : null,
                      onlyFuture: filterFutureEvents,
                      withCapacity: filterWithCapacity,
                      minPrice: priceRange.start.toInt(),
                      maxPrice: priceRange.end.toInt(),
                    );

                    savedMinPrice = priceRange.start;
                    savedMaxPrice = priceRange.end;

                    Navigator.pop(context, {
                      'filterFutureEvents': filterFutureEvents,
                      'filterWithCapacity': filterWithCapacity,
                      'sortOrder': sortOrder,
                      'minPrice': priceRange.start.toInt(),
                      'maxPrice': priceRange.end.toInt(),
                    });
                  },
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Map<String, String> _buildQueryParameters({
    bool? ascending,
    bool? onlyFuture,
    bool? withCapacity,
    int? minPrice,
    int? maxPrice,
    String? searchQuery,
    int? userId,
  }) {
    final today = DateTime.now().toIso8601String();
    return {
      if (ascending != null) '_sort': 'date',
      if (ascending == true) '_order': 'asc',
      if (ascending == false) '_order': 'desc',
      if (onlyFuture == true) 'date_gte': today,
      if (withCapacity != null && withCapacity == true)
        'filled': false.toString(),
      if (minPrice != null) 'price_gte': minPrice.toString(),
      if (maxPrice != null) 'price_lte': maxPrice.toString(),
      if (searchQuery != null) 'title_like': query.value,
      if (userId != null) 'userId': userId.toString(),
    };
  }



  Future<void> getBookmarked({bool? ascending,
    bool? onlyFuture,
    bool? withCapacity,
    int? minPrice,
    int? maxPrice}) async {
    isLoading.value = true;

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalKeys.userId) ?? -1;

    final queryParameters = _buildQueryParameters(
        ascending: ascending,
        onlyFuture: onlyFuture,
        withCapacity: withCapacity,
        minPrice: minPrice,
        maxPrice: maxPrice,
        searchQuery: query.value,
        userId: userId);
    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds') ?? [];

    final result = await _repository.getBookmarked(queryParameters: queryParameters, userId: userId );
    result.fold(
      (exception) {
        isLoading.value = false;
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              exception,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            backgroundColor: Colors.redAccent.withOpacity(.2),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      (eventsList) {
        isLoading.value = false;
        bookmarkedEvents.value = eventsList;
      },
    );
  }

  void initBookmarked() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds') ?? [];
    if (bookmarkedIds.isEmpty) {
      await preferences.setStringList('bookmarkedIds', []);
    }
  }

  Future<void> toggleBookmark({required int eventId}) async {
    isEventRefreshing[eventId] = true;
    isBookmarked.value = true;
    update();

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalKeys.userId) ?? -1;

    final String key = 'bookmarkedIds_$userId';
    List<String> bookmarkedIds = preferences.getStringList(key) ?? [];

    if (bookmarkedIds.contains(eventId.toString())) {
      bookmarkedIds.remove(eventId.toString());
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            "The bookmarked event was successfully deleted",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.greenAccent.withOpacity(.2),
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      bookmarkedIds.add(eventId.toString());
    }

    await preferences.setStringList(key, bookmarkedIds);

    final List<EventModel> updatedBookmarkedEvents = bookmarkedIds.map((id) {
      return bookmarkedEvents.firstWhere(
        (event) => event.id == int.parse(id),
        orElse: () => EventModel(
          id: int.parse(id),
          title: "Unknown",
          description: "",
          date: DateTime.now(),
          capacity: 0,
          price: 0,
          participants: 0,
          filled: false,
        ),
      );
    }).toList();

    bookmarkedEvents.value = updatedBookmarkedEvents;

    final BookmarkUserDto dto = BookmarkUserDto(bookmark: bookmarkedIds);
    final result = await _repository.editBookmarked(dto: dto, userId: userId);

    result.fold(
      (exception) {
        isBookmarked.value = false;
        isEventRefreshing[eventId] = false;
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              exception,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            backgroundColor: Colors.redAccent.withOpacity(0.2),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      (_) {
        isEventRefreshing[eventId] = false;
        isBookmarked.value = false;
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getBookmarked();
    getBookmarkedEvents();
  }
}
