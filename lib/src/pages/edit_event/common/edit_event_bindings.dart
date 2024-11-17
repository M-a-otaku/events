import 'package:get/get.dart';
import '../controllers/edit_event_controller.dart';


class EditEventBinding extends Bindings {
  @override
  void dependencies() {
    final parameters = Get.parameters;
    Get.lazyPut(() => EditEventController(eventId: parameters['id'] ?? ''));
  }
}
