import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../events.dart';
import '../../../../generated/locales.g.dart';
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
        messageText: Text(
          LocaleKeys.snack_bar_filled.tr,
          style: const TextStyle(color: Colors.black, fontSize: 14),
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
    final int userId = preferences.getInt(LocalStorageKeys.userId) ?? -1;

    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds_$userId') ?? [];


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
              title: Text(LocaleKeys.filter_Dialog_sort_filter.tr),
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
                    Text(
                      LocaleKeys.filter_Dialog_price_range.tr,
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
                      "${LocaleKeys.filter_Dialog_price_min.tr}: ${priceRange.start.toStringAsFixed(0)} - ${LocaleKeys.filter_Dialog_price_max.tr}: ${priceRange.end.toStringAsFixed(0)}",
                    ),
                    CheckboxListTile(
                      title:  Text(LocaleKeys.filter_Dialog_only_future.tr),
                      value: filterFutureEvents,
                      onChanged: (value) {
                        setState(() {
                          filterFutureEvents = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(LocaleKeys.filter_Dialog_only_capacity.tr),
                      value: filterWithCapacity,
                      onChanged: (value) {
                        setState(() {
                          filterWithCapacity = value!;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: sortOrder,
                      hint:  Text(LocaleKeys.filter_Dialog_sort_time.tr),
                      items: [
                        DropdownMenuItem(
                          value: LocaleKeys.filter_Dialog_sort_time_ascending.tr,
                          child:  Text(LocaleKeys.filter_Dialog_sort_time_ascending.tr),
                        ),
                        DropdownMenuItem(
                          value: LocaleKeys.filter_Dialog_sort_time_descending.tr,
                          child: Text(LocaleKeys.filter_Dialog_sort_time_descending.tr),
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
                  child: Text(LocaleKeys.filter_Dialog_cancel.tr),
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
                  child: Text(LocaleKeys.filter_Dialog_reset.tr),
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
                  child: Text(LocaleKeys.filter_Dialog_apply.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.event_page_logout.tr),
          content: Text(LocaleKeys.event_page_logout_validate.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(LocaleKeys.event_page_logout_no.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
              child: Text(LocaleKeys.event_page_logout_yes.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await Get.offAllNamed(RouteNames.login);
  }

  void onChangeLanguage() async {
    isLoading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? localeKey = pref.getString(LocalStorageKeys.languageLocale);
    if (localeKey == null) {
      localeKey = 'fa';
      pref.setString(LocalStorageKeys.languageLocale, 'fa');
    } else {
      if (localeKey == 'fa') {
        localeKey = 'en';
        pref.setString(LocalStorageKeys.languageLocale, 'en');
      } else if (localeKey == 'en') {
        localeKey = 'fa';
        pref.setString(LocalStorageKeys.languageLocale, 'fa');
      }
    }
    isLoading.value = false;
    Get.updateLocale(Locale(localeKey));
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


    final queryParameters = _buildQueryParameters(
        ascending: ascending,
        onlyFuture: onlyFuture,
        withCapacity: withCapacity,
        minPrice: minPrice,
        maxPrice: maxPrice,
        searchQuery: query.value,
        );


    final result = await _repository.getBookmarked(queryParameters: queryParameters);
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

  Future<void> toggleBookmark({required int eventId}) async {
    isEventRefreshing[eventId] = true;
    isBookmarked.value = true;
    update();

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalStorageKeys.userId) ?? -1;

    final String key = 'bookmarkedIds_$userId';
    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds_$userId') ?? [];

    if (bookmarkedIds.contains(eventId.toString())) {
      bookmarkedIds.remove(eventId.toString());
      Get.showSnackbar(
        GetSnackBar(
          messageText:  Text(
            LocaleKeys.bookmarked_Events_deleted.tr,
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
