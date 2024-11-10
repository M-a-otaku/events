import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.elliptical(70, 70))),
            child: Container(
              margin: EdgeInsets.only(bottom: 20, top: 20),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign in to continue.",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _body(),
        ],
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
            Obx(() => _login()),
            const SizedBox(height: 16),
            Hero(
              tag:_or(),
              child:_or(),
            ),
            const SizedBox(height: 16),
            // Obx(() => _register()),
            Hero(
              tag: Obx(() => _register()),
              child: Obx(() => _register()),
            )
          ],
        ),
      ),
    );
  }

  Widget _or() => (const Row(
        children: [
          Expanded(child: Divider()),
          Text(
            "   Or   ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Expanded(child: Divider()),
        ],
      ));

  Widget _login() => InkWell(
        onTap: (controller.isLoading.value) ? null : controller.toEventsPage,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                (controller.isLoading.value) ? Colors.grey : Colors.blueAccent,
          ),
          child: const Text(
            "Login",
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
              text: "Don't have a account . . . ",
              style: TextStyle(
                fontSize: 14,
                color:
                    (controller.isLoading.value) ? Colors.grey : Colors.black45,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Create One",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: (controller.isLoading.value)
                        ? Colors.grey
                        : Colors.blueAccent,
                  ),
                )
              ]),
        ),
      );

  Widget _username() {
    return TextFormField(
      controller: controller.usernameController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      validator: controller.validateUsername,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person_pin,
          color: Colors.grey,
        ),
        labelText: "username",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline_sharp,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
              onPressed: controller.onPressed,
              icon: Icon(controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off_outlined)),
          labelText: "password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
