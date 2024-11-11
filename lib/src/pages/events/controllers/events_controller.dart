import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/routes/route_names.dart';
import '../models/events_model.dart';
import '../models/events_user_dto.dart';
import '../repositories/events_repository.dart';

class EventsController extends GetxController {
  final int userId;

  EventsController({required this.userId});

  final EventsRepository _repository = EventsRepository();
  RxList<EventsModel> events = RxList();
  final RxList bookmarkedEvents = RxList();

  RxBool isFilled = false.obs;
  RxBool isExpired = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLimited = false.obs;
  RxBool isRetry = false.obs;

  Rx<RangeValues> priceLimits = Rx(const RangeValues(0, 1));
  double max = 1;
  double min = 0;


  Future<void> getUserById() async {
    isLoading.value = true;
    isRetry.value = false;
    final result = await _repository.getUserById(id: userId);
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
        );
      },
          (user) {
            isLoading.value =false;
            isRetry.value=false;
        bookmarkedEvents.value = user.bookmarked;
        getEvents();
      },
    );
  }

  Future<void> getEvents() async {
    events.clear();
    isLoading.value = true;
    isRetry.value = false;
    final result = await _repository.getEvents();
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
      (event) {
        isLoading.value = false;
        isRetry.value = false;
        events.value = event;
        event.addAll(events);
        calculateMinMax();
      },
    );
  }

  Future<void> onViewEvent(int eventId) async {
    await Get.toNamed(
      RouteNames.detailsEvent,
      parameters: {"eventId": "$eventId"},
    );

    getEvents();
  }

  Future<void> onBookmarks() async {
    await Get.toNamed(
      RouteNames.bookmark,
      parameters: {"userId": "$userId"},
    );
    getUserById();
  }

  void onChangedPrice(value) => priceLimits.value = value;

  void calculateMinMax() {
    if (events.isEmpty) {
      isLoading.value = false;
      isRetry.value = false;
      return;
    }

    double max = 0;
    double min = double.infinity;
    for (var event in events) {
      if (event.price > max) max = event.price;
      if (event.price < min) min = event.price;
    }
    this.max = max;
    this.min = min;
    priceLimits = Rx(RangeValues(min, max));
    isLoading.value = false;
    isRetry.value = false;
  }

  Future<void> onBookmark(int eventId) async {
    (bookmarkedEvents.contains(eventId))
        ? bookmarkedEvents.remove(eventId)
        : bookmarkedEvents.add(eventId);

    final EventsUserDto dto = EventsUserDto(bookmark: bookmarkedEvents);
    final result = await _repository.editBookmarked(dto: dto, userId: userId);
    result.fold(
          (exception) {
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
          (_) {
            Get.showSnackbar(
              GetSnackBar(
                messageText: const Text(
                  "the Event bookmarked successfully",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                backgroundColor: Colors.greenAccent.withOpacity(.2),
                duration: const Duration(seconds: 5),
              ),
            );
      },
    );
  }

  double get minPrice => priceLimits.value.start.floorToDouble();
  double get maxPrice => priceLimits.value.end.floorToDouble();

  // Future<void> goToEvent(int index) async {
  //   final EventsModel cat = Events[index];
  //   Get.toNamed(RouteNames.title, parameters: {"categoryId": '${cat.id}'});
  // }

  @override
  void onInit() {
    super.onInit();
    getUserById();
  }
}
