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

  RxBool isFilled = false.obs;
  RxBool isExpired = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLimited = false.obs;
  RxBool isRetry = false.obs;


  Future<void> goToEvent(int eventId) async {
    await Get.toNamed(
      RouteNames.detailsEvent,
      parameters: {"eventId": "$eventId"},
    );
  }


  Future<void> getEvents() async {
    // onRefresh();
    events.clear();
    isLoading.value = true;
    isRetry.value = false;

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ?? [];

    print("Fetching events from the repository...");
    final result = await _repository.getEvents();
    result.fold(
          (exception) {
        isLoading.value = false;
        isRetry.value = true;
        print("Error fetching events: $exception");
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
        // print("Events loaded successfully. Total events: ${events.length}");
      },
    );
  }
  Future<void> toggleBookmark(int eventId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    // بازیابی لیست بوک‌مارک‌ها از SharedPreferences
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ?? [];
    print("Current bookmarkedIds from SharedPreferences: $bookmarkedIds");

    if (bookmarkedIds.contains(eventId.toString())) {
      bookmarkedIds.remove(eventId.toString());  // اگر بوک‌مارک شده، آن را حذف کن
      print("Event $eventId removed from bookmarks.");
    } else {
      bookmarkedIds.add(eventId.toString());  // در غیر این صورت، آن را اضافه کن
      print("Event $eventId added to bookmarks.");
    }

    // ذخیره‌سازی لیست بوک‌مارک‌ها در SharedPreferences
    await preferences.setStringList('bookmarkedIds', bookmarkedIds);

    // به‌روزرسانی لیست محلی بوک‌مارک‌ها
    bookmarkedEvents.clear();
    bookmarkedEvents.addAll(bookmarkedIds.map(int.parse).toList());
    print("Updated bookmarkedEvents list: $bookmarkedEvents");

    // ارسال درخواست به سرور
    final EventsUserDto dto = EventsUserDto(bookmark: bookmarkedIds);
    final int userId = preferences.getInt(LocalKeys.userId) ?? -1;
    print("Sending updated bookmark list to the server for userId: $userId");
    final result = await _repository.editBookmarked(dto: dto, userId: userId);

    result.fold(
          (exception) {
        print("Error updating bookmarks on the server: $exception");
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
        print("Bookmark update successful on the server.");
        print("=--------------------------");

          },
    );
  }

  Future<void> onViewEvent(int eventId) async {
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
          "Event is Full you Can't Buy",
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
    // بازیابی بوکمارک‌ها بعد از دریافت رویدادها
    _loadBookmarkedEvents();
  }

  void _loadBookmarkedEvents() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ?? [];
    bookmarkedEvents.clear();
    bookmarkedEvents.addAll(bookmarkedIds.map(int.parse).toList());
    print("Bookmarked events loaded: $bookmarkedEvents");
  }

}
