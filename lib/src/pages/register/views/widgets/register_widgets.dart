import 'package:events/src/pages/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterWidgets extends StatelessWidget {
  final String gender;
  final String title;

  const RegisterWidgets({super.key, required this.gender, required this.title});

  @override
  Widget build(BuildContext context) => GetBuilder<RegisterController>(
    builder: (RegisterController) {
      return
      InkWell(
        onTap: () => RegisterController.changeGender(gender),
        child: Row(
          children: [
            Radio(
              value: gender,
              groupValue: RegisterController.maleUserGender,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (String? gender) {},
              activeColor: Theme
                  .of(context)
                  .primaryColor,
            ),
            Text(title)
          ],
        ),
      );
    }
  );
}
