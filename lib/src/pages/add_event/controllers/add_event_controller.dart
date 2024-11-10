import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/add_event_repository.dart';
import '../models/add_event_dto.dart';

class AddEventController extends GetxController {
  final AddEventRepository _repository = AddEventRepository();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  String? _selectedImage;
  String isImageUpload = "";
  var selectedTime = TimeOfDay.now().obs;

  final RxBool isLoading = false.obs;

  @override
  void onClose() {}

  chooseTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: selectedTime.value,
        builder: (context, child) {
          return Theme(
              data: ThemeData(colorSchemeSeed: Colors.blueAccent),
              child: child!);
        },
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: 'Select Departure Time',
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorInvalidText: 'Provide valid time',
        hourLabelText: 'Select Hour',
        minuteLabelText: 'Select Minute');
    if (pickedTime != null && pickedTime != selectedTime.value) {
      selectedTime.value = pickedTime;
    }
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    {
      _selectedImage = (returnedImage.path);
    }
  }

  Future<void> selectDate(context) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (_picked != null) {
      dateController.text = _picked.toString().split(" ")[0];
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  String? validate(String? value) {
    if (value != null && value.isEmpty) return 'required';
    return null;
  }

  String? validatePrice(String? value) {
    RegExp numberRegExp = RegExp(r'\d');
    if (value != null && value.isEmpty) {
      return 'please enter your amount';
    } else {
      if (!numberRegExp.hasMatch(value!)) {
        return "Please enter numbers ";
      } else {
        return null;
      }
    }
  }

  String? validateCapacity(String? value) {
    RegExp numberRegExp = RegExp(r'\d');
    if (value != null && value.isEmpty) {
      return 'please enter your amount';
    } else {
      if (!numberRegExp.hasMatch(value!)) {
        return "Please enter numbers ";
      } else {
        return null;
      }
    }
  }

  Future<void> onSubmit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    final int price = int.parse(priceController.text);
    final int capacity = int.parse(capacityController.text);
    final AddEventDto dto = AddEventDto(
        title: titleController.text,
        poster: _selectedImage,
        description: descriptionController.text,
        date: dateController.text,
        time: "${selectedTime.value.hour}:${selectedTime.value.minute}",
        capacity: capacity,
        price: price);

    final result = await _repository.addEvent(dto: dto);
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
      (event) {
        isLoading.value = false;
        Get.back<Map<String, dynamic>>(result: event);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}
