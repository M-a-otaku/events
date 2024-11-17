import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/event_details_controller.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RefreshIndicator(
            onRefresh: controller.onRefresh, child: Obx(() => _body(context))),
      ),
    );
  }



  Widget _body(context) {
    if (controller.isLoading.value) {
      return _loading();
    } else if (controller.isRetry.value) {
      return _retry();
    }
    return _success(context);
  }

  Widget _retry() {
    return Center(
      child: IconButton(
        tooltip: "press to refresh",
        hoverColor: Colors.blueAccent,
        highlightColor: Colors.white,
        onPressed: controller.getEventById,
        icon: const Icon(Icons.change_circle),
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _success(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Stack(
        children: [
          Image.asset(
            "Images/map.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          eventDetailAppbar(context),
          Positioned(
            left: 10,
            right: 10,
            bottom: 25,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 45),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(
                    () => Column(
                      children: [
                        eventInformation(),
                        const Divider(height: 15, color: Colors.white70),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              (controller.event.value.image != null &&
                                      controller.event.value.image!.isNotEmpty)
                                  ? Hero(
                                      tag:
                                          'event_${controller.event.value.id}_${UniqueKey()}',
                                      child: ClipOval(
                                        child: Image.memory(
                                          base64Decode(
                                              controller.event.value.image!),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Hero(
                                      tag:
                                          'event_${controller.event.value.id}_${UniqueKey()}',
                                      child: const Icon(Icons.event,
                                          color: Colors.white, size: 100),
                                    ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Title : ${controller.event.value.title}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "description : ${controller.event.value.description}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Row(
                                    children: [
                                      Text(
                                        "5.0",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.white, size: 16)
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        bookNow(context),
                                        submit(),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget submit() {
    return InkWell(
      onTap: () => controller.onSubmit(),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent,
        ),
        child: const Text(
          "Submit",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget bookNow(context) {
    return InkWell(
      onTap: () => controller.bookNow(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent,
        ),
        child: const Text(
          "Book Now",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Column eventInformation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "\$${controller.event.value.price.toString() ?? 'ناموجود'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                ' ${DateFormat('yyyy-MM-dd').format(controller.event.value.date)} ',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        const Text(
          "price",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Capacity: ${controller.event.value.capacity - controller.event.value.participants!}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  SafeArea eventDetailAppbar(BuildContext context) {
    return SafeArea(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        const Text(
          "event Detail",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ],
    ));
  }
}
