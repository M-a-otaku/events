import 'package:get/get.dart';
import '../controllers/event_details_controller.dart';

class EventDetailBindings extends Bindings {
  @override
  void dependencies() {
    int? eventId = int.parse(Get.parameters["eventId"] ?? '');
    Get.lazyPut(() => EventDetailsController(eventId: eventId));
  }
}
