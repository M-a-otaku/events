import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/event_details_controller.dart';
import '../models/event_details_model.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({super.key});

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _fab(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       appBar: _appBar(),
//       body: Obx(() => _body(context)),
//     );
//   }
//
//   Widget _fab() {
//     return (controller.isLoading.value)
//         ? const FloatingActionButton(
//             onPressed: null,
//             child: CircularProgressIndicator(),
//           )
//         : FloatingActionButton(
//             onPressed: controller.onSubmit,
//             child: const Icon(Icons.check),
//           );
//   }
//
//   AppBar _appBar() {
//     return AppBar(
//       title: const Text("Add Event"),
//       centerTitle: true,
//       automaticallyImplyLeading: false,
//     );
//   }
//
//   Widget _body(context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(vertical: 36),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Obx(() {
//               if (controller.events.value?.image != null) {
//                 return Image.memory(
//                   base64Decode(controller.imageBase64.value!),
//                   width: 333,
//                   height: 333,
//                 );
//               } else {
//                 const SizedBox(height: 32);
//                 return const Text("No image selected");
//               }
//             }),
//
//             ElevatedButton(
//               onPressed: () {
//                 controller.chooseTime();
//               },
//               child: const Text('Enter To Buy Ticket'),
//             ),
//             const SizedBox(height: 16),
//             // _datePicker(context)
//             // Obx(() => _register()),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Text("suiiiiiiiiii"),
          // for image
          Image.asset(
            "Images/map.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          carDetailAppbar(context),
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
                        cardInformation(),
                        const Divider(height: 15, color: Colors.white70),
                        Row(
                          children: [
                            (controller.event.value.image != null &&
                                    controller.event.value.image!.isNotEmpty)
                                ? ClipOval(
                                    child: Image.memory(
                                      base64Decode(
                                          controller.event.value.image!),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.event,
                                    color: Colors.white, size: 150),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "title",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            "LIcense: NWR 369852",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "369",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "Ride",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
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
                                            fontSize: 16),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueAccent,
                                        ),
                                        child: const Text(
                                          "Call",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueAccent,
                                        ),
                                        child: const Text(
                                          "Book Now",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
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

  // for car image
  // Positioned(
  //   right: 60,
  //   child: Hero(
  //     tag: car.image,
  //     child: Image.asset(
  //       car.image,
  //       height: 115,
  //     ),
  //   ),
  // ),

  Column cardInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$${controller.event.value.price.toString() ?? 'ناموجود'}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
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
              "Capacity : ${controller.event.value.capacity.toString() ?? 'ناموجود'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Text(
              ' ${DateFormat('yyyy-MM-dd').format(controller.event.value.date)} '
                  ' ${DateFormat('kk:mm').format(controller.event.value.date)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Text(
              "\$${controller.event.value.description.toString() ?? 'ناموجود'}",
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

  SafeArea carDetailAppbar(BuildContext context) {
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
