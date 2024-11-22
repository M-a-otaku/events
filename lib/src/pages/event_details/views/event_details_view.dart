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
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Obx(() => _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
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
        tooltip: "Press to refresh",
        onPressed: controller.getEventById,
        icon: const Icon(Icons.refresh, color: Colors.blueAccent, size: 30),
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _success(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Event image or default icon
          Hero(
            tag: 'event_${controller.event.value.id}_${UniqueKey()}',
            child: (controller.event.value.image != null &&
                controller.event.value.image!.isNotEmpty)
                ? Image.memory(
              base64Decode(controller.event.value.image!),
              height: 250,
              fit: BoxFit.cover,
            )
                : Container(
              height: 250,
              color: Colors.grey.shade300,
              child: const Icon(Icons.event, size: 100, color: Colors.white),
            ),
          ),

          // Event information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and description
                Text(
                  controller.event.value.title ?? "Event Title",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.event.value.description ?? "Event description",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const Divider(height: 20, color: Colors.grey),

                // Price and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${controller.event.value.price.toString() ?? 'N/A'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(controller.event.value.date),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Capacity
                Text(
                  "Remaining Capacity  :  ${controller.event.value.capacity - (controller.event.value.participants ?? 0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Book Now and Submit buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    bookNow(context),
                    submit(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget submit() {
    return ElevatedButton(
      onPressed: controller.onSubmit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text("Submit"),
    );
  }

  Widget bookNow(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller.bookNow(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text("Book Now"),
    );
  }
}
