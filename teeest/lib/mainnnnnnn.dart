import 'package:flutter/material.dart';
import 'package:get/get.dart';

// کنترلر که پارامتر را از طریق سازنده دریافت می‌کند
class HomeController extends GetxController {
  final String userId;

  HomeController(this.userId);
}

class SearchController extends GetxController {
  final String userId;

  SearchController(this.userId);
}

class ProfileController extends GetxController {
  final String userId;

  ProfileController(this.userId);
}

// Bindings برای مقداردهی اولیه کنترلرها
class MainBindings extends Bindings {
  @override
  void dependencies() {
    String userId = Get.parameters['userId'] ?? '';
    Get.put(BottomNavController());
    Get.put(HomeController(userId));
    Get.put(SearchController(userId));
    Get.put(ProfileController(userId));
  }
}

// کنترلر برای مدیریت وضعیت Bottom Navigation
class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}

// صفحات مختلف که از GetView استفاده می‌کنند
class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Page - User ID: ${controller.userId}'));
  }
}

class SearchPage extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search Page - User ID: ${controller.userId}'));
  }
}

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Page - User ID: ${controller.userId}'));
  }
}

class MainPage extends StatelessWidget {
  final BottomNavController navController = Get.find();

  @override
  Widget build(BuildContext context) {
    // لیست صفحات


    final List<Widget> pages = [
      HomePage(),
      SearchPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changePage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/previous',
    getPages: [
      GetPage(
        name: '/previous',
        page: () => PreviousPage(),
      ),
      GetPage(
        name: '/main',
        page: () => MainPage(),
        binding: MainBindings(), // استفاده از Bindings برای MainPage
      ),
    ],
  ));
}

// یک صفحه برای مسیریابی به MainPage با userId
class PreviousPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Previous Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // مسیریابی به MainPage و ارسال userId به عنوان پارامتر
            Get.toNamed('/main?userId=12345');
          },
          child: Text('Go to MainPage with userId'),
        ),
      ),
    );
  }
}
