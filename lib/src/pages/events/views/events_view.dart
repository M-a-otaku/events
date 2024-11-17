import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/events_controller.dart';
import 'widgets/events_widget.dart';
import 'widgets/filter_page.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

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
    } else if (controller.events.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "There is no event available ",
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
        highlightColor: Colors.white,
        onPressed: controller.getEvents,
        icon: const Icon(Icons.reset_tv),
        iconSize: 35,
      ),
    );
  }

  AppBar _appBar() => AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: const Text("home"),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            hoverColor: Colors.blueAccent,
            tooltip: "Press To Logout",
            color: Colors.white,
            onPressed: controller.logout,
          ),
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
            IconButton(
              icon: const Icon(Icons.filter_list),
              hoverColor: Colors.blueAccent,
              tooltip: "filter button",
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  Get.context!,
                  MaterialPageRoute(
                      builder: (_) => FilterPage()),  );
              },
            ),
            const SizedBox(width: 20),
          ]);

  Widget _success() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.events.length,
            itemBuilder: (_, index) => EventsWidget(
                event: controller.events[index],
                onBookmark: () =>
                    controller.toggleBookmark(controller.events[index].id),
                onTap: (controller.events[index].filled ||
                        controller.events[index].date.isBefore(DateTime.now()))
                    ? controller.filledEvent
                    : () => controller.goToEvent(controller.events[index].id)

                ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      );
}

class CustomSearchDelegate extends SearchDelegate {
  final EventsController controller = Get.find();
  bool isDescending = false;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          controller.searchEvents(
              query);
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
            subtitle: Text(event.description),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}

