import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../models/my_events_model.dart';
import '../repositories/my_events_repository.dart';

class MyEventsController extends GetxController {



  final MyEventsRepository _repository = MyEventsRepository();
  RxList<MyEventsModel> myEvents = RxList();
  RxBool isFilled = false.obs;
  RxBool isExpired = false.obs;
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;

  Rx<RangeValues> priceLimits = Rx(const RangeValues(0, 1));
  double max = 1;
  double min = 0;

  Future<void> getEvents() async {
    isLoading.value = true;
    isRetry.value = false;
    final result = await _repository.getMyEvents(creatorId: 1);
    result?.fold(
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
        );      },
      (events) {
        isLoading.value = false;
        isRetry.value = false;
        myEvents.addAll(events);
      },
    );
  }

  Future<void> addEvent() async {
    final result = await Get.toNamed(RouteNames.addEvents,
    parameters: {"creatorId": "1"});
    if (result != null) {
      myEvents.add(MyEventsModel.fromJson(json: result));
    }
  }

  Future<void> toEditPage({required int eventId}) async {
    final result = await Get.toNamed(
      RouteNames.editEvents,
      parameters: {"creatorId": "1", "eventId": "$eventId"},
    );
    if (result != null) {
      int index = myEvents.indexWhere((event) => event.id == eventId);
      myEvents[index] = MyEventsModel.fromJson(json: result);
    }
  }

  // Future<void> removeEvent ({required int eventId}) async {
  //   int index = myEvents.indexWhere((event) => event.id == eventId);
  //   if (myEvents[index].participants != 0) {
  //     Get.showSnackbar(
  //       GetSnackBar(
  //         messageText: const Text(
  //           "You Can't Delete Events When they're not empty",
  //           style: TextStyle(color: Colors.black, fontSize: 14),
  //         ),
  //         backgroundColor: Colors.redAccent.withOpacity(.2),
  //         duration: const Duration(seconds: 5),
  //       ),
  //     );
  //     return;
  //   }
  //   final result = await _repository.deleteEventById(eventId: eventId);
  //   result.fold(
  //         (exception) {
  //           Get.showSnackbar(
  //             GetSnackBar(
  //               messageText: Text(
  //                 exception,
  //                 style: const TextStyle(color: Colors.black, fontSize: 14),
  //               ),
  //               backgroundColor: Colors.redAccent.withOpacity(.2),
  //               duration: const Duration(seconds: 5),
  //             ),
  //           );
  //     },
  //         (_) {
  //       myEvents.removeAt(index);
  //       Get.showSnackbar(
  //         GetSnackBar(
  //           messageText: const Text(
  //             "Event deleted successfully",
  //             style: TextStyle(color: Colors.black, fontSize: 14),
  //           ),
  //           backgroundColor: Colors.greenAccent.withOpacity(.2),
  //           duration: const Duration(seconds: 5),
  //         ),
  //       );
  //     },
  //   );
  // }

  void onPriceChanged(value) => priceLimits.value = value;

  void calculateMinMax() {
    if (myEvents.isEmpty) {
      isLoading.value = false;
      isRetry.value = false;
      return;
    }

    double max = 0;
    double min = double.infinity;
    for (var event in myEvents) {
      if (event.price > max) max = event.price;
      if (event.price < min) min = event.price;
    }
    this.max = max;
    this.min = min;
    priceLimits = Rx(RangeValues(min, max));
    isLoading.value = false;
    isRetry.value = false;
  }

  double get minPrice => priceLimits.value.start.floorToDouble();
  double get maxPrice => priceLimits.value.end.floorToDouble();






  @override
  void onInit() {
    super.onInit();
    getEvents();
  }
}
