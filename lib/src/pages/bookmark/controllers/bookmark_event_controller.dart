import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../events.dart';
import '../models/event_model.dart';
import '../repositories/bookmark_event_repository.dart';

class BookmarkEventController extends GetxController {
  final _repository = BookmarkEventRepository();
  RxList<EventModel> bookmarkedEvents = RxList();
  RxList<EventModel> filteredEvents = <EventModel>[].obs;
  List bookmarkedIds = [];


  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;


  void searchEvents(String query) {
    if (query.isEmpty) {
      filteredEvents.value = bookmarkedEvents;
    } else {
      filteredEvents.value = bookmarkedEvents.where((event) {
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

    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ??
        [];

    return bookmarkedIds.map((id) => int.parse(id)).toList();
  }


  Future<void> getBookmarked() async {
    isLoading.value = true;
    final result = await _repository.getBookmarked(parameters: '');
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
          (eventsList) {
        isLoading.value = false;
        bookmarkedEvents.value = eventsList;
        filteredEvents.value = eventsList;
      },
    );
  }

  void initBookmarked() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ??
        [];
    if (bookmarkedIds.isEmpty) {
      await preferences.setStringList('bookmarkedIds', []);
    }
  }


  Future<void> onBookmark({required int eventId}) async {
    isLoading.value = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ??
        [];

    if (bookmarkedIds.contains(eventId.toString())) {
      isLoading.value = false;
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
    }

    bool isSaved = await preferences.setStringList(
        'bookmarkedIds', bookmarkedIds);
    getBookmarked();
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getBookmarked();
    getBookmarkedEvents();
  }

}
