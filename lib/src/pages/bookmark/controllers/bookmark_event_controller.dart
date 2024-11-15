import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../../shared/local_storage_keys.dart';
import '../models/bookmark_user_dto.dart';
import '../models/event_model.dart';
import '../repositories/bookmark_event_repository.dart';

class BookmarkEventController extends GetxController {
  final _repository = BookmarkEventRepository();
  RxList<EventModel> bookmarkedEvents = RxList();
  List bookmarkedIds = [];
  String params = '';

  final searchController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;
  RxBool isSearch = false.obs;

  Rx<RangeValues> priceLimits = Rx(const RangeValues(0, 1));
  double max = 1;
  double min = 0;

  Future<void> onRefresh() async {
    getBookmarked();
  }

  Future<List<int>> getBookmarkedEvents() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    // بازیابی لیست بوک‌مارک‌ها از SharedPreferences
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ?? [];

    // تبدیل لیست از String به int
    return bookmarkedIds.map((id) => int.parse(id)).toList();
  }


  Future<void> getBookmarked() async {
    final result = await _repository.getBookmarked(parameters: '');
    result.fold(
      (exception) {
        isSearch.value = false;
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
      },
    );
  }

  void initBookmarked() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ?? [];
    if (bookmarkedIds.isEmpty) {
      await preferences.setStringList('bookmarkedIds', []);
      print("Initialized empty bookmarkedIds");
    }
  }


  Future<void> onBookmark({required int eventId}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> bookmarkedIds = preferences.getStringList('bookmarkedIds') ?? [];

    // چک کردن که آیا ایونت قبلاً بوک‌مارک شده یا خیر
    if (bookmarkedIds.contains(eventId.toString())) {
      bookmarkedIds.remove(eventId.toString());
    } else {
      bookmarkedIds.add(eventId.toString());
    }

    // ذخیره کردن لیست بوک‌مارک‌ها
    bool isSaved = await preferences.setStringList('bookmarkedIds', bookmarkedIds);
    print("Bookmarked IDs after save: $bookmarkedIds");
    print("Is saved: $isSaved");  // برای بررسی موفقیت‌آمیز بودن ذخیره‌سازی

    // آپدیت کردن لیست بوک‌مارک‌ها
    getBookmarked();
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getBookmarked();
    getBookmarkedEvents();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
