import 'dart:convert';
import 'dart:typed_data';
import '../../../../generated/locales.g.dart';
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
  RxBool isRetry = false.obs;


  var selectedYear = DateTime.now().year.toString().obs;
  var selectedMonth = DateTime.now().month.toString().obs;
  var selectedDay = DateTime.now().day.toString().obs;
  final years =
      List<String>.generate(10, (i) => (DateTime.now().year + i).toString());
  final months =
      List<String>.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final days =
      List<String>.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));

  String formattedDate =
      DateFormat('yyyy-MM-dd    kk-mm').format(DateTime.now());


  final ImagePicker _picker = ImagePicker();
  var imageBase64 = Rx<String?>(null);

  var selectedTime2 = DateTime.now().obs;
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
    TimeOfDay initialTimeFromServer = TimeOfDay(
      hour: selectedTime2.value.hour,
      minute: selectedTime2.value.minute,
    );

    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: initialTimeFromServer,
      builder: (context, child) {
        return Theme(
          data: ThemeData(colorSchemeSeed: Colors.blueAccent),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: LocaleKeys.time_picker_help_text.tr,
      cancelText: LocaleKeys.time_picker_close.tr,
      confirmText: LocaleKeys.time_picker_confirm.tr,
      errorInvalidText: LocaleKeys.time_picker_error.tr,
      hourLabelText: LocaleKeys.time_picker_hour.tr,
      minuteLabelText: LocaleKeys.time_picker_minute.tr,

    );

    if (pickedTime != null) {
      selectedTime2.value = selectedTime2.value.copyWith(
        hour: pickedTime.hour,
        minute: pickedTime.minute,
      );

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
        selectedTime2.value.hour,
        selectedTime2.value.minute,
      );



      if (date.isBefore(DateTime.now())) {
        return null;
      }

      return date;
    } catch (e) {
      return null;
    }
  }

  String? validate(String? value) {
    if (value != null && value.isEmpty) return LocaleKeys.validate_required.tr;
    return null;
  }

  String? validatePrice(String? value) {
    RegExp numberRegExp = RegExp(r'\d');
    if (value != null && value.isEmpty) {
      return LocaleKeys.validate_numbers_empty.tr;
    } else {
      if (!numberRegExp.hasMatch(value!)) {
        return LocaleKeys.validate_numbers.tr;
      } else {
        return null;
      }
    }
  }

  String? validateCapacity(String? value) {
    RegExp numberRegExp = RegExp(r'\d');
    if (value == null || value.isEmpty) {
      return LocaleKeys.validate_numbers_empty.tr;
    } else if (!numberRegExp.hasMatch(value)) {
      return LocaleKeys.validate_numbers.tr;
    } else if (int.tryParse(value) == 0) {
      return LocaleKeys.validate_numbers_capacity.tr;
    } else {
      return null;  // Valid input
    }
  }

  Future<void> onSubmit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
     DateTime? date = selectedDate;
    if (date == null) {
      isLoading.value = false;
      Get.showSnackbar(GetSnackBar(
        message: "${LocaleKeys.snack_bar_date.tr} : $formattedDate .",
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    isLoading.value = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int price = int.parse(priceController.text);
    final int capacity = int.parse(capacityController.text);
    final AddEventDto dto = AddEventDto(
      title: titleController.text,
      image: imageBase64.value,
      description: descriptionController.text,
      date: date ,
      capacity: capacity,
      price: price,
      userId: preferences.getInt(LocalStorageKeys.userId) ?? -1,
      participants: 0,
      filled: false,
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
    capacityController.dispose();
    priceController.dispose();
  }
}
