import 'package:get/get.dart';
import '../controllers/my_events_controller.dart';

class MyEventsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyEventsController());
  }
}
