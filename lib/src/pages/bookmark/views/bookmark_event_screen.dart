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
          onRefresh: controller.onRefresh, child: Obx(() => _body())),
    );
  }

  Widget _body() {
    if (controller.isLoading.value) {
      return _loading();
    } else if (controller.isRetry.value) {
      return _retry();
    } else if (controller.bookmarkedEvents.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "No Events Bookmarked ",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          _retry()
        ],
      );
    }
    return _success();
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _retry() {
    return Center(
      child: IconButton(
        tooltip: "press to refresh",
        hoverColor: Colors.blueAccent,
        highlightColor: Colors.white ,
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          hoverColor: Colors.blueAccent,
          tooltip: "Search button",
          color: Colors.white,
          onPressed: () {
            showSearch(
              context: Get.context!,
              delegate: CustomSearchDelegate(),
            );
          },
        ),
        const SizedBox(width: 20),
      ]);

  Widget _success() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.bookmarkedEvents.length,
            itemBuilder: (_, index) => BookmarkEventWidget(
              event: controller.bookmarkedEvents[index],
              onBookmark: () => controller.onBookmark(
                eventId: controller.bookmarkedEvents[index].id,
              ), onTap: (controller.bookmarkedEvents[index].filled ||
                controller.bookmarkedEvents[index].date.isBefore(DateTime.now()))
                ? controller.filledEvent
                : () => controller.goToEvent(controller.bookmarkedEvents[index].id),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      );
}


class CustomSearchDelegate extends SearchDelegate {
  final BookmarkEventController controller = Get.find();
  bool isDescending = false;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          controller.searchEvents(query);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.searchEvents(query);
    return _buildEventList();
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchEvents(query);
    return _buildEventList();
  }

  Widget _buildEventList() {
    return Obx(
          () => ListView.builder(
        itemCount: controller.filteredEvents.length,
        itemBuilder: (context, index) {
          final event = controller.filteredEvents[index];
          return ListTile(
            title: Text(event.title),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}



