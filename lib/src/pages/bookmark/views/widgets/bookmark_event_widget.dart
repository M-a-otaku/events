import 'dart:convert';
import '../../controllers/bookmark_event_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event_model.dart';
import 'package:flutter/material.dart';

class BookmarkEventWidget extends GetView<BookmarkEventController> {
  const BookmarkEventWidget({
    super.key,
    required this.event,
    required this.onBookmark,
    required this.onTap,
  });

  final EventModel event;
  final void Function() onBookmark;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: (controller.isBookmarked.value) ? null : onTap,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueAccent[200],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: 0,
                      top: -20,
                      child: (event.image != null && event.image!.isNotEmpty)
                          ? Hero(
                              tag: 'event_${event.id}_${UniqueKey()}',
                              child: ClipOval(
                                child: Image.memory(
                                  base64Decode(event.image!),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Hero(
                              tag: 'event_${event.id}_${UniqueKey()}',
                              child: const Icon(
                                Icons.event,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\$${event.price}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        SelectableText(
                          "Title : ${event.title}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          "Description : ${event.description}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          ' ${DateFormat('yyyy-MM-dd').format(event.date)}  ${DateFormat('kk:mm').format(event.date)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
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
        ),
        Obx(() => Padding(
              padding: const EdgeInsets.all(2.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: (controller.isEventRefreshing[event.id] ?? false)
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.bookmark, color: Colors.blueAccent),
                  onPressed: (controller.isEventRefreshing[event.id] ?? false)
                      ? null
                      : () {
                          controller.onBookmark(eventId: event.id);
                        },
                  mouseCursor: (controller.isEventRefreshing[event.id] ?? false)
                      ? SystemMouseCursors.progress
                      : SystemMouseCursors.click,
                ),
              ),
            )),
      ],
    );
  }
}
