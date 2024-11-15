import '../controllers/bookmark_event_controller.dart';
import 'package:get/get.dart';

class BookmarkEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookmarkEventController());
  }
}
