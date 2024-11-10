import 'package:get/get.dart';
import '../../../../events.dart';

class SplashController extends GetxController {
  Future<void> splash() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(RouteNames.login);
  }
}