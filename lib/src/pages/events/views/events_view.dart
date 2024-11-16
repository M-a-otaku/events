import 'package:events/src/pages/events/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/events_controller.dart';
import 'widgets/events_widget.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
        onPressed: controller.getEvents,
        icon: const Icon(Icons.reset_tv),
        iconSize: 35,
      ),
    );
  }

  AppBar _appBar() => AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text("home"),
          leading: IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: controller.logout,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
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
            itemCount: controller.events.length,
            itemBuilder: (_, index) => EventsWidget(
                event: controller.events[index],
                onBookmark: () =>
                    controller.toggleBookmark(controller.events[index].id),
                onTap: (controller.events[index].filled)
                    ? controller.filledEvent
                    : () => controller.goToEvent(controller.events[index].id)
                // onTap: () {},
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
          controller.searchEvents(query); // Reset the search when the query is cleared
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
    controller.searchEvents(query); // Filter events as the user types
    return _buildEventList();
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    controller.searchEvents(query); // Filter events as the user types
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
              // Handle event tap
            },
          );
        },
      ),
    );
  }
}
  //
  // void toggle() {
  //   isDescending = !isDescending;
  // }


