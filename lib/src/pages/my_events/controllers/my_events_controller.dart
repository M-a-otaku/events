import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../models/my_events_model.dart';
import '../repositories/my_events_repository.dart';

class MyEventsController extends GetxController {
  final MyEventsRepository _repository = MyEventsRepository();
  RxList<MyEventsModel> Events = RxList();
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
        Events.addAll(categories);
      },
    );
  }

  Future<void> addEvent() async {
    final result = await Get.toNamed(RouteNames.addEvents);
    if (result != null) {
      Events.add(MyEventsModel.fromJson(json: result));
    }
  }



  @override
  void onInit() {
    super.onInit();
    getEvents();
  }
}
