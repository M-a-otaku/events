import 'package:events/src/pages/login/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/local_storage_keys.dart';

class LoginController extends GetxController {
  final LoginRepository _repository = LoginRepository();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool rememberMe = false.obs;

  void changeRemember(bool? val) {
    rememberMe.value = !rememberMe.value;
  }

  void onPressedVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
    if (value?.trim() != null && value!.trim().isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value!)) {
        return 'Please enter valid password minimum 8 Characters';
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
    isLoading.value = true;
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
      (response) async {
        isLoading.value = false;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (rememberMe.value) {
          preferences.setBool(LocalKeys.rememberMe, true);
        }
        preferences.setInt(LocalKeys.userId, response);
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
