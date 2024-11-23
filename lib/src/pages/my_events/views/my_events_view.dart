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
        onPressed: controller.getEvents,
        icon: const Icon(Icons.change_circle),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        centerTitle: true,
        title: const Text("My Events"),
        backgroundColor: Colors.grey,
      );

  Widget _fab() {
    return FloatingActionButton(
      onPressed: (controller.isLoading.value || controller.isRetry.value)
          ? controller.addEvent
          : controller.addEvent,
      child: const Icon(Icons.add),
    );
  }

  Widget _success(context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
    child: Obx(() => Stack(
      children: [
        Column(
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
                      labelText: 'Search by title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
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
          ],
        ),
        if (controller.isLoading.value)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    )),
  );
}
