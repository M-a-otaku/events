import 'package:events/src/pages/EEvents/controller/event_controller.dart';
import 'package:get/get.dart';

class EventBindings extends Bindings {
  @override
  void dependencies() {
    int? userId = int.parse(Get.parameters["userId"] ?? "");
    Get.lazyPut(() => EventController(userId: userId));
  }
}