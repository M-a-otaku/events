import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../../shared/local_storage_keys.dart';
import '../models/my_events_model.dart';
import '../repositories/my_events_repository.dart';

class MyEventsController extends GetxController {
  final MyEventsRepository _repository = MyEventsRepository();
  RxList<MyEventsModel> myEvents = RxList();
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;

  Future<void> getEvents() async {
    myEvents.clear();
    isLoading.value = true;
    isRetry.value = false;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userId = preferences.getInt(LocalKeys.userId) ?? -1;
    print("_______$userId");
    final result = await _repository.getMyEvents(userId: userId);
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
      (events) {
        isLoading.value = false;
        isRetry.value = false;
        myEvents.value = events;
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
    final result = await Get.toNamed(
      RouteNames.editEvents,
      parameters: {"creatorId": "1", "eventId": "$eventId"},
    );
    if (result != null) {
      int index = myEvents.indexWhere((event) => event.id == eventId);
      myEvents[index] = MyEventsModel.fromJson(json: result);
    }
  }

  Future<void> removeEvent({required int eventId}) async {
    int index = myEvents.indexWhere((event) => event.id == eventId);
    if (myEvents[index].participants != 0) {
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            "You Can't Delete Events When they're not empty",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.redAccent.withOpacity(.2),
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }
    final result = await _repository.deleteEventById(eventId: eventId);
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
        myEvents.removeAt(index);
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              "Event deleted successfully",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            backgroundColor: Colors.greenAccent.withOpacity(.2),
            duration: const Duration(seconds: 5),
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    getEvents();
  }
}
