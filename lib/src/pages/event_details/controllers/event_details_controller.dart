import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_details_dto.dart';
import '../models/event_details_model.dart';
import '../repositories/event_details_repository.dart';
import 'package:custom_number_picker/custom_number_picker.dart';


class EventDetailsController extends GetxController {
  int eventId;

  EventDetailsController({required this.eventId});

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



  }

  Future<void> onRefresh() async {
    getEventById();
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
          (events) {
        isLoading.value = false;
        event.value = events;
      },
    );
  }

  Future<void> onSubmit() async {
    isLoading.value = true;
    int updatedParticipants = (event.value.participants ?? 0) + _selectedNumber;
    bool fill = updatedParticipants >= event.value.capacity;


    final EventDetailsDto dto = EventDetailsDto(
      participants: updatedParticipants,
      filled: fill,
    );

    final result = await _repository.purchaseEvent(dto: dto, eventId: "$eventId");
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
        event["participants"] = updatedParticipants;
        event["filled"] = fill;
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
