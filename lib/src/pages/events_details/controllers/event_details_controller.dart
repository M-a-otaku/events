import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_details_dto.dart';
import '../models/event_details_model.dart';
import '../repositories/event_details_repository.dart';
import 'package:custom_number_picker/custom_number_picker.dart';


class EventDetailsController extends GetxController {
  int eventId;

  EventDetailsController({required this.eventId});

  Rxn<EventDetailsModel> events = Rxn();
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;
  var _selectedNumber = 0;

  final EventDetailsRepository _repository = EventDetailsRepository();

  Rx<EventDetailsModel> event = Rx(EventDetailsModel(
    userId: 0,
    capacity: 0,
    date: DateTime(2010),
    id: 0,
    image: '',
    title: '',
    filled: false,
    description: '',
    price: 0,
    participants: 0,
  ));

  void bookNow(BuildContext context) {
    print("Current Participants: ${event.value.participants}");
    print("Selected Number: $_selectedNumber");

    showDialog(

      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select a Number"),
        content: NumberPicker(
          initialValue: _selectedNumber,
          min: 0,
          max: event.value.capacity - event.value.participants!,
          step: 1,
          onChanged: (value) {
            _selectedNumber = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
    print("Current Participants22222222: ${event.value.participants}");
    print("Selected Number2222222222222222222: $_selectedNumber");


  }


  Future<void> getEventById() async {
    isLoading.value = true;
    isRetry.value = false;

    final result = await _repository.getEventById(eventId: "$eventId");
    result.fold(
          (exception) {
        isLoading.value = false;
        isRetry.value = true;
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
          (eventss) {
        isLoading.value = false;
        event.value = eventss;
        events.value = eventss;

        // پرینت مقادیر دریافتی از سرور
        print("Received Event Details: ${eventss.participants}");
        print("Received Capacity: ${eventss.capacity}");

        // بررسی مقدار اولیه participants
        print("Initial Participants: ${event.value.participants}");
      },
    );
  }

  Future<void> onSubmit() async {
    isLoading.value = true;

    // چاپ مقادیر فعلی
    print("Current Participants: ${event.value.participants}");
    print("Selected Number: $_selectedNumber");

    // محاسبه تعداد کل شرکت‌کنندگان با اضافه کردن مقدار انتخاب شده
    int updatedParticipants = (event.value.participants ?? 0) + _selectedNumber;

    // چاپ مقدار جدید participants پس از اضافه کردن
    print("Updated Participants: $updatedParticipants");

    // بررسی اگر ظرفیت پر شده باشد
    bool fill = updatedParticipants >= event.value.capacity;

    // چاپ وضعیت پر بودن رویداد
    print("Event Filled: $fill");

    final EventDetailsDto dto = EventDetailsDto(
      participants: updatedParticipants,
      filled: fill,
    );

    final result = await _repository.purchaseEvent(dto: dto, eventId: "$eventId");
    result?.fold(
          (exception) {
        isLoading.value = false;
        print("Error: $exception");
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
        // چاپ مقدار نهایی event پس از بروزرسانی
        print("Updated Event: $event");
        event["participants"] = updatedParticipants;
        event["filled"] = fill;
        print("Final Participants: ${event["participants"]}");
        print("Final Filled: ${event["filled"]}");
        isLoading.value = false;
        Get.back(result: event);
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    getEventById();
  }
}
