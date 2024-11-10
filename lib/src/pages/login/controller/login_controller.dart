import 'package:events/src/pages/login/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/routes/route_names.dart';

class LoginController extends GetxController {
  final LoginRepository _repository = LoginRepository();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isLoggedIn = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("username")) {
      if (prefs.getString("username") == usernameController.text &&
          prefs.getString("password") == passwordController.text) {
        isLoggedIn(true);
      } else {
        isLoggedIn(false);
      }
    }
  }

  Future<void> emptyPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("password");
  }

  void emptyController() {
    usernameController.text = "";
    passwordController.text = "";
  }

  void onPressed() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
    if (value?.trim() != null && value!.trim().isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value!)) {
        return '''Please enter valid password 
    minimum 8 to maximum 20 Characters
        ''';
      } else {
        return null;
      }
    }
  }

  String? validateUsername(String? value) {
    if (value?.trim() != null && value!.trim().isEmpty) {
      return 'Please enter Username';
    } else {
      return null;
    }
  }

  Future<void> toEventsPage() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // isLoading.value = true;
    // if (usernameController.text.trim() == usernameController.text &&
    //     passwordController.text.trim() == passwordController.text) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("username", usernameController.text.trim().toString());
    //   prefs.setString("password", passwordController.text.trim().toString());
    //   emptyController();
    //   isLoggedIn(true);
    // }
    final result = await _repository.login(
      username: usernameController.text,
      password: passwordController.text,
    );

    result?.fold(
      (exception) {
        isLoading.value = false;
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              exception,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            backgroundColor: Colors.redAccent.withOpacity(.2),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      (success) {
        isLoading.value = false;
        // Get.offNamed(RouteNames.events);
        // Get.offNamed(RouteNames.car);
        Get.offNamed(RouteNames.home);
      },
    );
  }

  Future<void> toRegister() async {
    final result = await Get.toNamed(RouteNames.register);
    if (result != null) {
      usernameController.text = result["username"];
      passwordController.text = result["password"];
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            ('user successfully created'),
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.green.withOpacity(.2),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
}
