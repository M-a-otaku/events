import 'package:events/src/pages/bottom_nav_bar/controller/nav_bar_controller.dart';
import 'package:events/src/pages/events/controllers/events_controller.dart';
import 'package:get/get.dart';

import '../../EEvents/controller/event_controller.dart';
import '../../my_events/controllers/my_events_controller.dart';

class NavBarBindings extends Bindings{
  @override
  void dependencies() {
    int? userId = int.parse(Get.parameters["userId"] ?? "");
    Get.lazyPut(()=> NavBarController(userId: userId));
    Get.lazyPut(()=> EventController(userId: userId));
    Get.lazyPut(()=> EventsController(userId: userId));
    Get.lazyPut(()=> MyEventsController(userId:userId));
  }


}