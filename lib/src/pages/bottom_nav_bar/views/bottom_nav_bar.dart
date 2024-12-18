import 'package:events/generated/locales.g.dart';

import '../../bookmark/views/bookmark_event_screen.dart';
import '../controller/nav_bar_controller.dart';
import '../../events/views/events_view.dart';
import '../../my_events/views/my_events_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends GetView<NavBarController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (controller) {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex,
          children: const [EventsView(), MyEventsView(), BookmarkEventScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blueAccent,
            onTap: controller.changeIndex,
            currentIndex: controller.currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              _BottomNavigationBarItem(
                  icon: Icons.home, label: LocaleKeys.bottom_nav_bar_home.tr),
              _BottomNavigationBarItem(
                  icon: Icons.event,
                  label: LocaleKeys.bottom_nav_bar_my_events.tr),
              _BottomNavigationBarItem(
                  icon: Icons.book_outlined,
                  label: LocaleKeys.bottom_nav_bar_bookmark.tr),
            ]),
      );
    });
  }

  BottomNavigationBarItem _BottomNavigationBarItem(
          {required IconData icon, required String label}) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);
}
