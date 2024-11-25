import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../generated/locales.g.dart';
import '../repositories/login_repository.dart';
import '../../../infrastructure/routes/route_names.dart';
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
      return   LocaleKeys.login_page_validate_password.tr;
    } else {
      if (!regex.hasMatch(value!)) {
        return LocaleKeys.login_page_validate_password_min.tr;
      } else {
        return null;
      }
    }
  }

  String? validateUsername(String? value) {
    if (value?.trim() != null && value!.trim().isEmpty) {
      return LocaleKeys.login_page_validate_username.tr;
    } else {
      return null;
    }
  }

  Future<void> toEventsPage() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    final result = await _repository.login(
      username: usernameController.text.toLowerCase(),
      password: passwordController.text,
    );
    result.fold(
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
          preferences.setBool(LocalStorageKeys.rememberMe, true);
        }
        preferences.setInt(LocalStorageKeys.userId, response);
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
          messageText: Text(
            LocaleKeys.login_page_create_user.tr,
            style: const TextStyle(color: Colors.black, fontSize: 14),
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
