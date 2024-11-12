import 'package:get/get.dart';
import '../controllers/add_event_controller.dart';

class AddEventBindings extends Bindings {
  @override
  void dependencies() {
    int? userId = int.parse(Get.parameters["userId"] ?? "");
    Get.lazyPut(() => AddEventController(userId: userId));
  }
}
