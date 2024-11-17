import 'package:get/get.dart';
import '../../bookmark/controllers/bookmark_event_controller.dart';
import '../../events/controllers/events_controller.dart';
import '../../my_events/controllers/my_events_controller.dart';

class NavBarController extends GetxController {
  int currentIndex = 0;

  // Modify the changeIndex method
  void changeIndex(int index) {
    currentIndex = index;

    // Call methods to update data based on the index
    if (currentIndex == 0) {
      Get.find<EventsController>().getEvents(); // Example method
    } else if (currentIndex == 1) {
      Get.find<MyEventsController>().getEvents(); // Example method
    } else if (currentIndex == 2) {
      Get.find<BookmarkEventController>().getBookmarked(); // Example method
    }

    update(); // Update the UI
  }
}
