import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bookmark_event_controller.dart';
import 'widgets/bookmark_event_widget.dart';

class BookmarkEventScreen extends GetView<BookmarkEventController> {
  const BookmarkEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: _appBar(),
      body: RefreshIndicator(
          onRefresh: controller.onRefresh, child: Obx(() => _body(context))),
    );
  }

  Widget _body(context) {
    if (controller.isRetry.value) {
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
        onPressed: controller.getBookmarked,
        icon: const Icon(Icons.refresh),
        iconSize: 35,
      ),
    );
  }

  AppBar _appBar() => AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: const Text("bookmark"),
      );

  Widget _success(context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Obx(
          () => Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt),
                    tooltip: "Sort and Filter",
                    onPressed: () {
                      controller.showSortAndFilterDialog(
                        context,
                        initialFilterFutureEvents:
                            controller.filterFutureEvents,
                        initialFilterWithCapacity:
                            controller.filterWithCapacity,
                        initialMaxPrice: controller.savedMaxPrice,
                        initialMinPrice: controller.savedMinPrice,
                        initialSortOrder: controller.sortOrder,
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (searchQuery) {
                        controller.updateSearchQuery(searchQuery);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search Bookmarked Events',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child:
                            CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: controller.bookmarkedEvents.length,
                        itemBuilder: (_, index) => BookmarkEventWidget(
                          event: controller.bookmarkedEvents[index],
                          onBookmark: () => controller.onBookmark(
                            eventId: controller.bookmarkedEvents[index].id,
                          ),
                          onTap: (controller.bookmarkedEvents[index].filled ||
                                  controller.bookmarkedEvents[index].date
                                      .isBefore(DateTime.now()))
                              ? controller.filledEvent
                              : () => controller.goToEvent(
                                  controller.bookmarkedEvents[index].id),
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                      ),
              ),
            ],
          ),
        ),
      );
}
