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
  var userId = 0.obs;

  RxBool isFilled = false.obs;
  RxBool isExpired = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLimited = false.obs;
  RxBool isRetry = false.obs;

  Future<void> getEvents() async {
    events.clear();
    isLoading.value = true;
    isRetry.value = false;
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
      (event) {
        isLoading.value = false;
        isRetry.value = false;
        events.value = event;
      },
    );
  }

  Future<void> onRefresh() async {
    getEvents();
  }

  Future<void> onViewEvent(int eventId) async {
    await Get.toNamed(
      RouteNames.detailsEvent,
      parameters: {"eventId": "$eventId"},
    );

    getEvents();
  }
  Future<void> logout() async {
    await Get.toNamed(
      RouteNames.login,
    );
  }

  // Future<void> onBookmarks() async {
  //   await Get.toNamed(
  //     RouteNames.bookmark,
  //     parameters: {"userId": "$userId"},
  //   );
  //   // getUserById();
  //   getEvents();
  // }

  // Future<void> onBookmark(int eventId) async {
  //   (bookmarkedEvents.contains(eventId))
  //       ? bookmarkedEvents.remove(eventId)
  //       : bookmarkedEvents.add(eventId);
  //
  //   final EventsUserDto dto = EventsUserDto(bookmark: bookmarkedEvents);
  //   final result = await _repository.editBookmarked(dto: dto, userId: userId);
  //   result.fold(
  //         (exception) {
  //           Get.showSnackbar(
  //             GetSnackBar(
  //               messageText: Text(
  //                 exception,
  //                 style: const TextStyle(color: Colors.black, fontSize: 14),
  //               ),
  //               backgroundColor: Colors.redAccent.withOpacity(.2),
  //               duration: const Duration(seconds: 5),
  //             ),
  //           );
  //     },
  //         (_) {
  //           Get.showSnackbar(
  //             GetSnackBar(
  //               messageText: const Text(
  //                 "the Event bookmarked successfully",
  //                 style: TextStyle(color: Colors.black, fontSize: 14),
  //               ),
  //               backgroundColor: Colors.greenAccent.withOpacity(.2),
  //               duration: const Duration(seconds: 5),
  //             ),
  //           );
  //     },
  //   );
  // }

  // Future<void> goToEvent(int index) async {
  //   final EventsModel cat = Events[index];
  //   Get.toNamed(RouteNames.title, parameters: {"categoryId": '${cat.id}'});
  // }

  void _loadUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId.value = preferences.getInt(LocalKeys.userId) ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    getEvents();
    _loadUserId();
  }
}
