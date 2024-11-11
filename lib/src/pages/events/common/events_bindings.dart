import 'package:get/get.dart';
import '../controllers/events_controller.dart';

class EventsBindings extends Bindings {
  @override
  void dependencies() {
    int? userId = int.parse(Get.parameters["userId"] ?? "");
    Get.lazyPut(() => EventsController(userId: userId));
  }
}
