import '../model/event_model.dart';
import '../repositories/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final int userId;
  EventController({required this.userId});


  final EventRepository _repository = EventRepository();
RxList<EventModel> events = RxList();
RxBool isLoading = false.obs;
RxBool isRetry = false.obs;

RxBool isDescending = false.obs;

Future<void> getEvents() async {
  isLoading.value = true;
  isRetry.value = false;
  final result = await _repository.getEvents();
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
      events.addAll(events);
    },
  );
}


@override
void onInit() {
  super.onInit();
  getEvents();
}

}

