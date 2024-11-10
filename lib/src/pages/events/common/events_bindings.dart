import 'package:get/get.dart';
import '../controllers/events_controller.dart';

class EventsBindings extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => EventsController());
}
