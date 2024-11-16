import 'dart:convert';
import 'dart:typed_data';

import 'package:events/src/pages/bookmark/controllers/bookmark_event_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import 'package:flutter/material.dart';

class BookmarkEventWidget extends GetView<BookmarkEventController> {
  const BookmarkEventWidget({
    super.key,
    required this.event,
    required this.onBookmark,
  });

  final EventModel event;
  final void Function() onBookmark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            // onTap: onTap,
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
                    child: (event.image != null && event.image!.isNotEmpty)
                        ? ClipOval(
                            child: Image.memory(
                              base64Decode(event.image!),
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
                        "\$${event.price}",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "Title : ${event.title}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "Description : ${event.description}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        ' ${DateFormat('yyyy-MM-dd').format(event.date)}  ${DateFormat('kk:mm').format(event.date)}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (event.filled)
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
                            '${event.participants ?? 0} / ${event.capacity}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "\$${event.price}",
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
              icon: const Icon(
                Icons.bookmark,
                color: Colors.blueAccent,
              ),
              onPressed: onBookmark,
            ),
          ),
        ),
      ],
    );
  }
}
