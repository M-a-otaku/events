import '../../../../generated/locales.g.dart';
import 'widgets/register_widgets.dart';
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
                          bottomRight: Radius.elliptical(70, 70))),
                  child: Hero(tag: _icon(), child: _icon()),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.register_page_welcome.tr,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        LocaleKeys.register_page_information.tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _body(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _icon() {
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

  Widget _body(context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _firstname(context),
            const SizedBox(height: 16),
            _lastname(context),
            const SizedBox(height: 16),
            _username(context),
            const SizedBox(height: 16),
            _password(context),
            const SizedBox(height: 16),
            _repeatPassword(),
            const SizedBox(height: 16),
            RegisterWidgets(
                gender: controller.maleUserGender,
                title: LocaleKeys.register_page_male.tr),
            RegisterWidgets(
                gender: controller.femaleUserGender,
                title: LocaleKeys.register_page_female.tr),
            const SizedBox(height: 16),
            Obx(() => _register()),
            const SizedBox(height: 16),
            Hero(
              tag: _or(),
              child: _or(),
            ),
            const SizedBox(height: 16),
            Hero(
              tag: Obx(() => _login()),
              child: Obx(() => _login()),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _or() => (Row(
        children: [
          const Expanded(child: Divider()),
          Text(
            "   ${LocaleKeys.register_page_or.tr}   ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const Expanded(child: Divider()),
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
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  LocaleKeys.register_page_register.tr,
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
              text: "",
              style: TextStyle(
                fontSize: 14,
                color:
                    (controller.isLoading.value) ? Colors.grey : Colors.black45,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: LocaleKeys.register_page_back_login.tr,
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

  Widget _firstname(context) {
    return Obx(() => TextFormField(
          maxLength: 20,
          controller: controller.firstnameController,
          focusNode: controller.firstnameFocus,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(controller.lastnameFocus);
          },
          textInputAction: TextInputAction.next,
          validator: controller.validate,
          readOnly: (controller.isLoading.value ? true : false),
          decoration: InputDecoration(
            counter: const Offstage(),
            labelText: LocaleKeys.register_page_firstname.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ));
  }

  Widget _lastname(context) {
    return Obx(() => TextFormField(
          maxLength: 20,
          controller: controller.lastnameController,
          focusNode: controller.lastnameFocus,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(controller.usernameFocus);
          },
          textInputAction: TextInputAction.next,
          validator: controller.validate,
          readOnly: (controller.isLoading.value ? true : false),
          decoration: InputDecoration(
            counter: const Offstage(),
            labelText: LocaleKeys.register_page_lastname.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ));
  }

  Widget _username(context) {
    return Obx(
      () => TextFormField(
        maxLength: 20,
        controller: controller.usernameController,
        focusNode: controller.usernameFocus,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(controller.passwordFocus);
        },
        textInputAction: TextInputAction.next,
        validator: controller.validateUsername,
        readOnly: (controller.isLoading.value ? true : false),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          labelText: LocaleKeys.register_page_username.tr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _password(context) {
    return Obx(
      () => TextFormField(
        maxLength: 20,
        controller: controller.passwordController,
        validator: controller.validatePassword,
        focusNode: controller.passwordFocus,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(controller.repeatPasswordFocus);
        },
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
          labelText: LocaleKeys.register_page_password.tr,
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
        focusNode: controller.repeatPasswordFocus,
        textInputAction: TextInputAction.next,
        obscureText: controller.isRepeatPasswordVisible.value,
        readOnly: (controller.isLoading.value ? true : false),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          suffixIcon: IconButton(
              onPressed: controller.onPressedRepeat,
              icon: Icon(controller.isRepeatPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off_outlined)),
          labelText: LocaleKeys.register_page_repeat_password.tr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
