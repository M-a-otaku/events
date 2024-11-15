import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/my_events_controller.dart';
import '../../models/my_events_model.dart';

class MyEventsWidget extends GetView<MyEventsController> {
  const MyEventsWidget({
    super.key,
    required this.myEvent,
    required this.removeEvent,
    required this.onTap,
  });

  final void Function() onTap;
  final void Function() removeEvent;
  final MyEventsModel myEvent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blueAccent[200],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Positioned image
                  Positioned(
                    right: 0,
                    top: -20,
                    child: (myEvent.image != null && myEvent.image!.isNotEmpty)
                        ? ClipOval(
                            child: Image.memory(
                              base64Decode(myEvent.image!),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.event,
                            color: Colors.white,
                            size: 80,
                          ),
                  ),
                  // Text information
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${myEvent.price}",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "Title : ${myEvent.title}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "Description : ${myEvent.description}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      
                      Text(
                        ' ${DateFormat('yyyy-MM-dd').format(myEvent.date)}  ${DateFormat('kk:mm').format(myEvent.date)}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (myEvent.filled)
                              ? const Text(
                                  'This event Is Full',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              : const Text(
                                  '',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                          const SizedBox(width: 8),
                          Text(
                            '${myEvent.participants ?? 0} / ${myEvent.capacity}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "\$${myEvent.price}",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: (myEvent.participants != 0) ? null : removeEvent,
              icon: const Icon(Icons.delete_forever_outlined , color: Colors.redAccent,),
              mouseCursor: (myEvent.participants != 0)
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.grab,
            ),
          ),
        )
      ],
    );
  }
}
