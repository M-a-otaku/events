import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../generated/locales.g.dart';
import '../../controllers/my_events_controller.dart';
import '../../models/my_events_model.dart';

class MyEventsWidget extends GetView<MyEventsController> {
  const MyEventsWidget({
    super.key,
    required this.myEvent,
    required this.removeEvent,
    required this.onTap,
  });

  final void Function()? onTap;
  final void Function() removeEvent;
  final MyEventsModel myEvent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      shadowColor: Colors.grey.shade300,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: ( controller.isEventRemoving[myEvent.id] ?? false) ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (myEvent.image != null && myEvent.image!.isNotEmpty)
                    ? Image.memory(
                        base64Decode(myEvent.image!),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.event,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            myEvent.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "\$${myEvent.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      myEvent.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('yyyy-MM-dd').format(myEvent.date),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('HH:mm').format(myEvent.date),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myEvent.filled
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:  Text(
                                  LocaleKeys.event_page_full.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:  Text(
                                  LocaleKeys.event_page_available.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        Text(
                          '${myEvent.participants ?? 0} / ${myEvent.capacity}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: ((controller.isEventRemoving[myEvent.id] ?? false) ||
                          (myEvent.participants != 0 &&
                              myEvent.date.isAfter(DateTime.now())))
                      ? null
                      : () => controller.showDeleteConfirmationDialog(
                          context, removeEvent),
                  child: MouseRegion(
                    cursor: (myEvent.participants != 0 &&
                            myEvent.date.isAfter(DateTime.now()))
                        ? SystemMouseCursors.forbidden
                        : (controller.isEventRemoving[myEvent.id] ?? false)
                            ? SystemMouseCursors.progress
                            : SystemMouseCursors.grab,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: (controller.isEventRemoving[myEvent.id] ?? false)
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.redAccent,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
