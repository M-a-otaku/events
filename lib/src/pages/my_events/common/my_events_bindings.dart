import 'package:get/get.dart';
import '../controllers/my_events_controller.dart';

class MyEventsBindings extends Bindings {
  @override
  void dependencies() {
    int? userId = int.parse(Get.parameters["userId"] ?? "");
    Get.lazyPut(() => MyEventsController(userId: userId));
  }
}
