import 'dart:async';
import 'package:events/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../../shared/local_storage_keys.dart';
import '../models/events_user_dto.dart';
import '../models/my_events_model.dart';
import '../repositories/my_events_repository.dart';

class MyEventsController extends GetxController {
  final MyEventsRepository _repository = MyEventsRepository();
  RxList<MyEventsModel> myEvents = RxList();
  RxList<int> bookmarkedEvents = <int>[].obs;

  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;
  RxBool isRemoving = false.obs;
  RxList<MyEventsModel> filteredEvents = <MyEventsModel>[].obs;
  final RxMap<int, bool> isEventRemoving = <int, bool>{}.obs;
  var query = ''.obs;

  bool filterFutureEvents = false;
  bool filterWithCapacity = false;
  String? sortOrder;
  double savedMinPrice = 0;
  double savedMaxPrice = 9999;
  Timer? _debounce;


  void updateSearchQuery(String searchQuery) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      isLoading.value = true;
      query.value = searchQuery;
      getEvents();
    });
  }

  void showDeleteConfirmationDialog(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title:  Text(LocaleKeys.my_event_delete.tr),
          content:  Text(LocaleKeys.my_event_delete_validate.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child:  Text(LocaleKeys.event_page_logout_no.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              child:  Text(
                LocaleKeys.event_page_logout_yes.tr,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
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


  Future<void> toggleBookmark(int eventId) async {

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalStorageKeys.userId) ?? -1;
    final String key = 'bookmarkedIds_$userId';
    List<String> bookmarkedIds = preferences.getStringList(key) ?? [];

    if (bookmarkedIds.contains(eventId.toString())) {
      bookmarkedIds.remove(eventId.toString());
    } else {
      bookmarkedIds.add(eventId.toString());
    }

    await preferences.setStringList(key, bookmarkedIds);

    bookmarkedEvents.clear();
    bookmarkedEvents.addAll(bookmarkedIds.map(int.parse).toList());

    final EventsUserDto dto = EventsUserDto(bookmark: bookmarkedIds);
    final result = await _repository.editBookmarked(dto: dto, userId: userId);

    result.fold(
          (exception) {
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
      },
    );
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
                    getEvents();
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

                    await getEvents(
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

  Future<void> getEvents(
      {bool? ascending,
      bool? onlyFuture,
      bool? withCapacity,
      int? minPrice,
      int? maxPrice}) async {
    myEvents.clear();
    isLoading.value = true;
    isRetry.value = false;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalStorageKeys.userId) ?? -1;

    final queryParameters = _buildQueryParameters(
        ascending: ascending,
        onlyFuture: onlyFuture,
        withCapacity: withCapacity,
        minPrice: minPrice,
        maxPrice: maxPrice,
        searchQuery: query.value,
        userId: userId);

    final result =
        await _repository.fetchMyEvents(queryParameters: queryParameters);
    result?.fold(
      (exception) {
        isLoading.value = false;
        isRetry.value = true;
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
      (events) {
        isLoading.value = false;
        isRetry.value = false;
        myEvents.value = events;
        filteredEvents.value = events;
      },
    );
  }

  Future<void> onRefresh() async {
    getEvents();
  }

  Future<void> addEvent() async {
    final result = await Get.toNamed(RouteNames.addEvents);
    if (result != null) {
      myEvents.add(MyEventsModel.fromJson(json: result));
    }
  }

  Future<void> toEditPage({required int eventId}) async {
    int index = myEvents.indexWhere((event) => event.id == eventId);
    final result = await Get.toNamed(
      RouteNames.editEvents,
      parameters: {"id": "$eventId"},
    );
    if (result != null) {
      MyEventsModel newEvent = MyEventsModel.fromJson(json: result);
      if (index != -1) {
        myEvents[index] = myEvents[index].copyWith(
          date: newEvent.date,
          filled: newEvent.filled,
          participants: newEvent.participants,
          title: newEvent.title,
          description: newEvent.description,
          image: newEvent.image,
          price: newEvent.price,
          userId: newEvent.userId,
          id: newEvent.id,
          capacity: newEvent.capacity,
        );
      }
    }
    getEvents();
  }

  Future<void> removeEvent({required int eventId}) async {
    isEventRemoving[eventId] = true;

    int index = myEvents.indexWhere((event) => event.id == eventId);
    final isBookmarked = await _checkIfEventIsBookmarked(eventId);
    if (isBookmarked) {
      await _removeEventFromBookmarks(eventId);
    }

    final result = await _repository.deleteEventById(eventId: eventId);
    result.fold(
          (exception) {
        isEventRemoving[eventId] = false;
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
        if (index != -1) {
          myEvents.removeAt(index);
        }
        isEventRemoving[eventId] = false;
        Get.showSnackbar(
          GetSnackBar(
            messageText:  Text(
             LocaleKeys.my_event_delete_success.tr,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            backgroundColor: Colors.greenAccent.withOpacity(0.2),
            duration: const Duration(seconds: 5),
          ),
        );
        toggleBookmark(eventId);
      },
    );
  }

  Future<bool> _checkIfEventIsBookmarked(int eventId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<int> bookmarkedEventIds = prefs.getStringList('bookmarkedEventIds')?.map((e) => int.parse(e)).toList() ?? [];
    return bookmarkedEventIds.contains(eventId);
  }

  Future<void> _removeEventFromBookmarks(int eventId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<int> bookmarkedEventIds = prefs.getStringList('bookmarkedEventIds')?.map((e) => int.parse(e)).toList() ?? [];
    bookmarkedEventIds.remove(eventId);
    await prefs.setStringList('bookmarkedEventIds', bookmarkedEventIds.map((e) => e.toString()).toList());
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


  @override
  void onInit() {
    super.onInit();
    getEvents();
  }
}
