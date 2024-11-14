import 'package:events/src/pages/register/views/widgets/register_widgets.dart';
import 'package:flutter/services.dart';

import '../controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBar(),
      body: SingleChildScrollView(
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
                      bottomRight: Radius.elliptical(70, 70))),
              child: Hero(tag: _icon(), child: _icon()),
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
                    "Please Enter Your Information.",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _body(),
          ],
        ),
      ),
    );
  }
  Widget _icon(){
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 20),
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
            _firstname(),
            const SizedBox(height: 16),
            _lastname(),
            const SizedBox(height: 16),
            _username(),
            const SizedBox(height: 16),
            _password(),
            const SizedBox(height: 16),
            _repeatPassword(),
            const SizedBox(height: 16),
            RegisterWidgets(gender: controller.maleUserGender, title: "male"),
            RegisterWidgets(
                gender: controller.femaleUserGender, title: "female"),
            const SizedBox(height: 16),
            Obx(() => _register()),
            const SizedBox(height: 16),
            Hero(
              tag: _or(),
              child: _or(),
            ),
            const SizedBox(height: 16),
            // Obx(() => _login()),
            Hero(
              tag: Obx(() => _login()),
              child: Obx(() => _login()),
            ),
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

  Widget _register() => InkWell(
        onTap: (controller.isLoading.value) ? null : controller.doRegister,
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
            "Register",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _login() => InkWell(
        onTap: (controller.isLoading.value) ? null : controller.onLogin,
        borderRadius: BorderRadius.circular(12),
        child: RichText(
          text: TextSpan(
              text: "Back To . . .",
              style: TextStyle(
                fontSize: 14,
                color:
                    (controller.isLoading.value) ? Colors.grey : Colors.black45,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "  login",
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

  Widget _firstname() {
    return Obx(() => TextFormField(
          maxLength: 20,
          controller: controller.firstnameController,
          autofocus: true,
          textInputAction: TextInputAction.next,
          validator: controller.validate,
          readOnly: (controller.isLoading.value ? true : false),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          decoration: InputDecoration(
            counter: const Offstage(),
            labelText: "Firstname",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ));
  }

  Widget _lastname() {
    return Obx(() => TextFormField(
          maxLength: 20,
          controller: controller.lastnameController,
          autofocus: true,
          textInputAction: TextInputAction.next,
          validator: controller.validate,
          readOnly: (controller.isLoading.value ? true : false),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          decoration: InputDecoration(
            counter: const Offstage(),
            labelText: "Firstname",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ));
  }

  Widget _username() {
    return Obx(
      () => TextFormField(
        maxLength: 20,
        controller: controller.usernameController,
        textInputAction: TextInputAction.next,
        validator: controller.validateUsername,
        readOnly: (controller.isLoading.value ? true : false),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          labelText: "username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _password() {
    return Obx(
      () => TextFormField(
        maxLength: 20,
        controller: controller.passwordController,
        validator: controller.validatePassword,
        textInputAction: TextInputAction.next,
        obscureText: controller.isPasswordVisible.value,
        readOnly: (controller.isLoading.value ? true : false),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
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

  Widget _repeatPassword() {
    return Obx(
      () => TextFormField(
        maxLength: 20,
        controller: controller.repeatPassController,
        validator: controller.validatePassword,
        textInputAction: TextInputAction.next,
        obscureText: controller.isrepeatPasswordVisible.value,
        readOnly: (controller.isLoading.value ? true : false),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          suffixIcon: IconButton(
              onPressed: controller.onPressedRepeat,
              icon: Icon(controller.isrepeatPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off_outlined)),
          labelText: "repeat password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
