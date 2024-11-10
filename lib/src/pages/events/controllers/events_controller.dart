import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../models/events_model.dart';
import '../repositories/events_repository.dart';

class EventsController extends GetxController {
  final EventsRepository _repository = EventsRepository();
  RxList<EventsModel> events = RxList();
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;

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
        );      },
      (categories) {
        isLoading.value = false;
        isRetry.value = false;
        events.addAll(categories);
      },
    );
  }

  // Future<void> goToEvent(int index) async {
  //   final EventsModel cat = Events[index];
  //   Get.toNamed(RouteNames.title, parameters: {"categoryId": '${cat.id}'});
  // }




  @override
  void onInit() {
    super.onInit();
    getEvents();
  }
}
