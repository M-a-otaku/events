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
      print(result["time"]);
      myEvents.add(MyEventsModel.fromJson(json: result));
    }
  }

  Future<void> toEditPage({required int eventId}) async {
    // isLoading.value = true;
    int index = myEvents.indexWhere((event) => event.id == eventId);
    if (myEvents[index].participants != 0) {
      isLoading.value = false;
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            "You Can't edit Events When they're not empty",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.redAccent.withOpacity(.2),
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }

    final result = await Get.toNamed(
      RouteNames.editEvents,
      parameters: {"id": "$eventId"},
    );
    if (result != null) {
      MyEventsModel newEvent = MyEventsModel.fromJson(json: result);
      if(index != -1){
        myEvents[index]=myEvents[index].copyWith(
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
  }

  Future<void> removeEvent({required int eventId}) async {
    isLoading.value = true;
    int index = myEvents.indexWhere((event) => event.id == eventId);
    if (myEvents[index].participants != 0) {
      isLoading.value = false;
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
      (_) {
        isLoading.value = false;
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
