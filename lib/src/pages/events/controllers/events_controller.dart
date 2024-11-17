import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../../shared/local_storage_keys.dart';
import '../models/events_model.dart';
import '../models/events_user_dto.dart';
import '../repositories/events_repository.dart';

class EventsController extends GetxController {
  final EventsRepository _repository = EventsRepository();
  RxList<EventsModel> events = RxList();
  final RxList bookmarkedEvents = RxList();
  RxList<EventsModel> filteredEvents = <EventsModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;

  String selectedTitleFilter = '';
  String selectedDateFilter = '';
  String selectedCapacityFilter = '';
  bool isFilledFilter = false;

  void filterEvents() {
    filteredEvents.value = events.where((event) {
      bool matchesTitle =
          event.title.toLowerCase().contains(selectedTitleFilter.toLowerCase());
      bool matchesDate =
          event.date.toIso8601String().contains(selectedDateFilter);
      bool matchesCapacity =
          event.capacity.toString().contains(selectedCapacityFilter);
      bool matchesFilled = (isFilledFilter) ? event.filled : true;

      return matchesTitle && matchesDate && matchesCapacity && matchesFilled;
    }).toList();
  }

  void searchEvents(String query) {
    if (query.isEmpty) {
      filteredEvents.value = events;
    } else {
      filteredEvents.value = events.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> goToEvent(int eventId) async {
    await Get.toNamed(
      RouteNames.detailsEvent,
      parameters: {"eventId": "$eventId"},
    );
  }


  Future<void> getEvents() async {
    events.clear();
    isLoading.value = true;
    isRetry.value = false;

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds') ?? [];

    final result = await _repository.getEvents();
    result.fold(
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
      (eventList) {
        isLoading.value = false;
        isRetry.value = false;
        events.value = eventList;
        filteredEvents.value = events;
        // print("Events loaded successfully. Total events: ${events.length}");
      },
    );
  }

  Future<void> toggleBookmark(int eventId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds') ?? [];

    if (bookmarkedIds.contains(eventId.toString())) {
      bookmarkedIds
          .remove(eventId.toString());
    } else {
      bookmarkedIds.add(eventId.toString());
    }

    await preferences.setStringList('bookmarkedIds', bookmarkedIds);

    bookmarkedEvents.clear();
    bookmarkedEvents.addAll(bookmarkedIds.map(int.parse).toList());

    final EventsUserDto dto = EventsUserDto(bookmark: bookmarkedIds);
    final int userId = preferences.getInt(LocalKeys.userId) ?? -1;
    final result = await _repository.editBookmarked(dto: dto, userId: userId);

    result.fold(
      (exception) {
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
      (_) {
      },
    );
  }

  Future<void> toDetailsEvent(int eventId) async {
    await Get.toNamed(
      RouteNames.detailsEvent,
      parameters: {"eventId": "$eventId"},
    );

    getEvents();
  }

  Future<void> logout() async {
    await Get.offAndToNamed(
      RouteNames.login,
    );
  }

  Future<void> onRefresh() async {
    getEvents();
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

  void _loadUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalKeys.userId) ?? -1;
    print("Loaded userId from SharedPreferences: $userId");
  }

  @override
  void onInit() {
    super.onInit();
    getEvents();
    _loadUserId();
    _loadBookmarkedEvents();
  }

  void _loadBookmarkedEvents() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds =
        preferences.getStringList('bookmarkedIds') ?? [];
    bookmarkedEvents.clear();
    bookmarkedEvents.addAll(bookmarkedIds.map(int.parse).toList());
  }
}
