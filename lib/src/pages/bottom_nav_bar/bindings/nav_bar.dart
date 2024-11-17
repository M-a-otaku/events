import '../../bookmark/controllers/bookmark_event_controller.dart';
import '../controller/nav_bar_controller.dart';
import '../../events/controllers/events_controller.dart';
import 'package:get/get.dart';
import '../../my_events/controllers/my_events_controller.dart';

class NavBarBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> NavBarController());
    Get.lazyPut(()=> EventsController());
    Get.lazyPut(()=> MyEventsController());
    Get.lazyPut(()=> BookmarkEventController());
  }


}