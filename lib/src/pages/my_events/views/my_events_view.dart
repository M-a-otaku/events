import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_events_controller.dart';
import 'widgets/my_events_widget.dart';

class MyEventsView extends GetView<MyEventsController> {
  const MyEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Obx(() => _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (controller.isRetry.value) {
      return _retry();
    }
    if (controller.myEvents.isEmpty && !controller.isLoading.value) {
      return _emptyState(context);
    }
    return _success(context);
  }

  Widget _retry() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Failed to load events.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          IconButton(
            tooltip: "Press to refresh",
            hoverColor: Colors.blueAccent,
            highlightColor: Colors.white,
            onPressed: controller.getEvents,
            icon: const Icon(Icons.refresh, size: 32, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Colors.blue),
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
                    decoration: InputDecoration(
                      labelText: 'Search by title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No events available.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
    centerTitle: true,
    title: const Text("My Events"),
    backgroundColor: Colors.blueAccent,
  );

  Widget _fab() {
    return FloatingActionButton(
      onPressed: controller.addEvent,
      child: const Icon(Icons.add),
    );
  }

  Widget _success(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
    child: Obx(
          () => Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.blue),
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
                      decoration: InputDecoration(
                        labelText: 'Search by title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.search),
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
                      eventId: controller.myEvents[index].id,
                    ),
                    onTap: (controller.isRemoving.value)
                        ? null
                        : () => controller.toEditPage(
                        eventId: controller.myEvents[index].id),
                  ),
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                ),
              ),
            ],
          ),
          if (controller.isLoading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    ),
  );
}
