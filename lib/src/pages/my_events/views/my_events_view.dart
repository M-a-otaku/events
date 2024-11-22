import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/my_events_controller.dart';
import 'widgets/my_events_widget.dart';

class MyEventsView extends GetView<MyEventsController> {
  const MyEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    } else if (controller.myEvents.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "MyEvents is empty",
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
        icon: const Icon(Icons.change_circle),
      ),
    );
  }

  AppBar _appBar() => AppBar(
          centerTitle: true,
          title: const Text("My Events"),
          backgroundColor: Colors.grey,
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

  Widget _fab() {
    return FloatingActionButton(
      onPressed: (controller.isLoading.value || controller.isRetry.value)
          ? controller.addEvent
          : controller.addEvent,
      child: const Icon(Icons.add),
    );
  }

  Widget _success() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.myEvents.length,
            itemBuilder: (_, index) => MyEventsWidget(
              myEvent: controller.myEvents[index],
              removeEvent: () => controller.removeEvent(
                  eventId: controller.myEvents[index].id),
              onTap: (controller.isRemoving.value)
                  ? null
                  : () => controller.toEditPage(
                      eventId: controller.myEvents[index].id),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      );
}

class CustomSearchDelegate extends SearchDelegate {
  final MyEventsController controller = Get.find();
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
            onTap: () {},
          );
        },
      ),
    );
  }
}
