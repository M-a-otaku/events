import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_details_dto.dart';
import '../models/event_details_model.dart';
import '../repositories/event_details_repository.dart';

class EventDetailsController extends GetxController {
  int eventId;

  EventDetailsController({required this.eventId});

  Rxn<EventDetailsModel> events = Rxn();
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;

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
  ));

  Future<void> getEventById() async {
    print("Event Details: ${event.value}");
    print("Image: ${event.value.image}");
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
        isLoading.value = false;
        event.value = eventss;
        events.value = eventss;
        print(eventss);
        print(event);
        print(events);
      },
    );
  }

  Future<void> onSubmit() async {
    isLoading.value = true;
    final EventDetailsDto dto = EventDetailsDto(
      participants: 0,
      filled: false,
    );

    final result =
        await _repository.purchaseEvent(dto: dto, eventId: "$eventId");
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
  void onInit() {
    super.onInit();
    getEventById();
  }
}
