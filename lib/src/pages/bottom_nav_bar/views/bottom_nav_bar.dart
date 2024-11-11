import 'package:events/src/pages/EEvents/views/events_screen.dart';
import 'package:events/src/pages/bottom_nav_bar/controller/nav_bar_controller.dart';
import 'package:events/src/pages/events/views/events_view.dart';
import 'package:events/src/pages/my_events/views/my_events_view.dart';
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
          children: const [
            EventsView(),
            MyEventsView(),
            EventsScreen(),
          ],
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
              _BottomNavigationBarItem(icon: Icons.home, label: "Home"),
              _BottomNavigationBarItem(icon: Icons.event, label: "My Events"),
              _BottomNavigationBarItem(
                  icon: Icons.book_outlined, label: "Bookmarks"),
            ]),
      );
    });
  }

  BottomNavigationBarItem _BottomNavigationBarItem(
          {required IconData icon, required String label}) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);
}
