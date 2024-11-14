import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/local_storage_keys.dart';
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

  var selectedYear = ''.obs;
  var selectedMonth = ''.obs;
  var selectedDay = ''.obs;
  final years =
      List<String>.generate(10, (i) => (DateTime.now().year + i).toString());
  final months =
      List<String>.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final days =
      List<String>.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));

  String formattedDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 1)));

  final ImagePicker _picker = ImagePicker();
  var imageBase64 = Rx<String?>(null);

  var selectedTime = TimeOfDay.now().obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {}

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      imageBase64.value = base64Image;
    }
  }

  Future<void> chooseTime() async {
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
      print(pickedTime);
      print(selectedTime);
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

  DateTime? get selectedDate {
    if (selectedYear.value.isEmpty ||
        selectedMonth.value.isEmpty ||
        selectedDay.value.isEmpty) {
      return null;
    }

    try {
      final date = DateTime(
        int.parse(selectedYear.value),
        int.parse(selectedMonth.value),
        int.parse(selectedDay.value),
      );

      if (date.isBefore(DateTime.now().add(const Duration(days: 1)))) {
        return null;
      }

      return date;
    } catch (e) {
      return null;
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
    final DateTime? date = selectedDate;
    if (date == null) {
      Get.showSnackbar(GetSnackBar(
        message: "please choose valid date after tomorrow : $formattedDate .",
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    isLoading.value = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    print("${preferences.getInt(LocalKeys.userId) ?? -1}");
    final int price = int.parse(priceController.text);
    final int capacity = int.parse(capacityController.text);
    final AddEventDto dto = AddEventDto(
      title: titleController.text,
      image: imageBase64.value,
      description: descriptionController.text,
      date: date.toString(),
      time: "$selectedTime",
      capacity: capacity,
      price: price,
      userId: preferences.getInt(LocalKeys.userId) ?? -1,
      participants: 0, filled: false,
    );

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
        Get.back(result: event);
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
