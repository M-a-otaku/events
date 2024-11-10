import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  RxBool isrepeatPasswordVisible = true.obs;
  RxBool isLoading = false.obs;

  void changeGender(String gender) {
    _maleUserGender = gender;
    update();
  }

  String? validate(String? value) {
    if (value != null && value.isEmpty) return 'required';
    return null;
  }

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
    if (value != null && value.isEmpty) {
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
    ;
    if (value != null && value.isEmpty) {
      return 'Please enter Username';
    } else {
      return null;
    }
  }

  Future<void> doRegister() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (passwordController.text != repeatPassController.text) {
      Get.showSnackbar(GetSnackBar(
          messageText: const Text(
            ('Password is not matching'),
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          backgroundColor: Colors.redAccent.withOpacity(.2),
          duration: const Duration(seconds: 5)));
      return;
    }
    isLoading.value = true;

    final RegisterDto dto = RegisterDto(
      username: usernameController.text,
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
    isrepeatPasswordVisible.value = !isrepeatPasswordVisible.value;
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
