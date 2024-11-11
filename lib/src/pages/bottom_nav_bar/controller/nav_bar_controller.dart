import 'package:get/get.dart';

class NavBarController extends GetxController {
  final int userId;

  NavBarController({required this.userId});

  int currentIndex = 0;

  void changeIndex(int index){
    currentIndex = index;
    update();
  }
}