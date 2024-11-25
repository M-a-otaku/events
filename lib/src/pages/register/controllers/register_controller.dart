import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../models/register_dto.dart';
import '../repositories/register_repository.dart';

class RegisterController extends GetxController {
  final RegisterRepository _repository = RegisterRepository();
  final usernameController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _maleUserGender = 'male';

  String get maleUserGender => _maleUserGender;
  final String femaleUserGender = 'female';

  RxBool isPasswordVisible = true.obs;
  RxBool isRepeatPasswordVisible = true.obs;
  RxBool isLoading = false.obs;

  final FocusNode firstnameFocus = FocusNode();
  final FocusNode lastnameFocus = FocusNode();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode repeatPasswordFocus = FocusNode();


  void changeGender(String gender) {
    _maleUserGender = gender;
    update();
  }

  String? validate(String? value) {
    if (value != null && value.isEmpty) return LocaleKeys.validate_required.tr;
    return null;
  }

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
    if (value != null && value.isEmpty) {
      return LocaleKeys.login_page_validate_password.tr;
    } else {
      if (!regex.hasMatch(value!)) {
        return LocaleKeys.login_page_validate_password_min.tr;
      } else {
        return null;
      }
    }
  }

  String? validateUsername(String? value) {
    ;
    if (value != null && value.isEmpty) {
      return LocaleKeys.login_page_validate_username.tr;
    } else {
      return null;
    }
  }

  Future<void> doRegister() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (passwordController.text != repeatPassController.text) {
      Get.showSnackbar(GetSnackBar(
          messageText:  Text(
            LocaleKeys.register_page_password_not_match.tr ,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.redAccent.withOpacity(.2),
          duration: const Duration(seconds: 5)));
      return;
    }
    isLoading.value = true;

    final RegisterDto dto = RegisterDto(
      username: usernameController.text.toLowerCase(),
      password: passwordController.text,
      gender: _maleUserGender,
      firstname: firstnameController.text,
      lastname: lastnameController.text,
    );

    final result = await _repository.register(dto);

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
      (map) {
        isLoading.value = false;
        Get.back(result: map);
      },
    );
  }

  void onPressed() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void onPressedRepeat() {
    isRepeatPasswordVisible.value = !isRepeatPasswordVisible.value;
    update();
  }

  void onLogin() => Get.back();

  @override
  void dispose() {
    super.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    repeatPassController.dispose();
  }
}
