import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/local_storage_keys.dart';
import '../models/edit_event_dto.dart';
import '../repositories/edit_event_repository.dart';

class EditEventController extends GetxController {
  final String eventId;

  EditEventController({required this.eventId});

  RxMap imagePick = RxMap();

  final EditEventRepository _repository = EditEventRepository();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool filled = false.obs;
   RxInt participants = 0.obs;

  var selectedYear = ''.obs;
  var selectedMonth = ''.obs;
  var selectedDay = ''.obs;
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

  void updateFilledStatus() {
    filled.value = participants.value >= int.parse(capacityController.text);
  }


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
      helpText: 'Select Departure Time',
      cancelText: 'Close',
      confirmText: 'Confirm',
      errorInvalidText: 'Provide valid time',
      hourLabelText: 'Select Hour',
      minuteLabelText: 'Select Minute',
    );

    if (pickedTime != null) {
      selectedTime2.value = selectedTime2.value.copyWith(
        hour: pickedTime.hour,
        minute: pickedTime.minute,
      );


    }
  }

  DateTime? previousDate;

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

      if (date.isBefore(DateTime.now()) && date != previousDate) {
        return null;
      }

      return date;
    } catch (e) {
      return null;
    }
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
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
    if (value == null || value.isEmpty) {
      return 'Please enter your amount';
    } else if (!numberRegExp.hasMatch(value)) {
      return "Please enter numbers only";
    } else if (int.tryParse(value) == 0) {
      return "Capacity cannot be 0";
    } else {
      return null;  // Valid input
    }
  }

  void showSnackbar(String message) {
    Get.snackbar(
      "Action Not Allowed",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,
    );
  }


  Future<void> onSubmit() async {
    isLoading.value = true;
    if (!(formKey.currentState?.validate() ?? false)) {
      isLoading.value = false;
      return;
    }

    DateTime? date = selectedDate;
    if (date == null) {
      isLoading.value = false;
      Get.showSnackbar(GetSnackBar(
        message: "please choose valid date after tomorrow : $formattedDate .",
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int price = int.parse(priceController.text);
    final int capacity = int.parse(capacityController.text);
    updateFilledStatus();
    final result = await _repository.editEvent(
        eventId: eventId,
        dto: EditEventDto(
          image: imageBase64.value,
            userId: preferences.getInt(LocalStorageKeys.userId) ?? -1,
            filled: filled.value,
            title: titleController.text,
            description: descriptionController.text,
            date: date,
            capacity: capacity,
            participants: participants.value,
            price: price));
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

  void getEvent(String eventId) async {
    isLoading.value = true;
    final result = await _repository.getEventById(eventId: eventId);

    result.fold((exception) {
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
    }, (right) {
      isLoading.value = false;
      selectedDay.value = right.date.day.toString();
      selectedMonth.value = right.date.month.toString();
      selectedYear.value = right.date.year.toString();
      previousDate = right.date;
      titleController.text = right.title;
      descriptionController.text = right.description;
      priceController.text = right.price.toString();
      priceController.text = right.price.toString();
      selectedTime2.value = right.date.toLocal();
      imageBase64.value = right.image;
      capacityController.text = right.capacity.toString();
      participants.value = right.participants ?? 0;
      updateFilledStatus();
    });
  }

  @override
  void onInit() {
    super.onInit();
    getEvent(eventId);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    capacityController.dispose();
  }
}
