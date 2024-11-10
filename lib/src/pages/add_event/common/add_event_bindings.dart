import 'package:get/get.dart';
import '../controllers/add_event_controller.dart';

class AddEventBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddEventController());
  }
}
