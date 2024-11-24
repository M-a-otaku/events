import 'package:events/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(70, 70),
                    ),
                  ),
                  child: Hero(tag: _icon(), child: _icon()),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.login_page_welcome.tr,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        LocaleKeys.login_page_sign_in.tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                _body(),
              ],
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Icon(
        Icons.person,
        size: 50,
      ),
    );
  }

  Widget _body() {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _username(),
            const SizedBox(height: 16),
            _password(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                      () => Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: (controller.isLoading.value
                        ? null
                        : controller.changeRemember),
                  ),
                ),
                const SizedBox(width: 6),
                 Text(LocaleKeys.login_page_remember_me.tr),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => _login()),
            const SizedBox(height: 16),
            _or(),
            const SizedBox(height: 16),
            Hero(
              tag: Obx(() => _register()),
              child: Obx(() => _register()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _or() =>  Row(
    children: [
      Expanded(child: Divider()),
      Text(
        "   ${LocaleKeys.register_page_or.tr}   ",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      Expanded(child: Divider()),
    ],
  );

  Widget _login() => InkWell(
    onTap: (controller.isLoading.value) ? null : controller.toEventsPage,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (controller.isLoading.value) ? Colors.grey : Colors.blueAccent,
      ),
      child:  Text(
        LocaleKeys.login_page_login.tr,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _register() => InkWell(
    onTap: (controller.isLoading.value) ? null : controller.toRegister,
    child: RichText(
      text: TextSpan(
        text: "",
        style: TextStyle(
          fontSize: 14,
          color: (controller.isLoading.value) ? Colors.grey : Colors.black45,
        ),
        children: <TextSpan>[
          TextSpan(
            text: LocaleKeys.login_page_register.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: (controller.isLoading.value)
                  ? Colors.grey
                  : Colors.blueAccent,
            ),
          )
        ],
      ),
    ),
  );

  Widget _username() {
    return Obx(
          () => TextFormField(
        maxLength: 20,
        controller: controller.usernameController,
        autofocus: true,
        textInputAction: TextInputAction.next,
        validator: controller.validateUsername,
        readOnly: controller.isLoading.value,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          prefixIcon: const Icon(Icons.person_pin, color: Colors.grey),
          labelText: LocaleKeys.login_page_username.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _password() {
    return Obx(
          () => TextFormField(
        controller: controller.passwordController,
        validator: controller.validatePassword,
        textInputAction: TextInputAction.next,
        obscureText: controller.isPasswordVisible.value,
        maxLength: 20,
        readOnly: controller.isLoading.value,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          prefixIcon: const Icon(Icons.lock_outline_sharp, color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: controller.onPressedVisible,
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off_outlined,
            ),
          ),
          labelText: LocaleKeys.login_page_password.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
