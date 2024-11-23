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
      appBar: _appBar(context),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Obx(() => _body(context)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (controller.isRetry.value) {
      return _retry();
    }
    if (controller.events.isEmpty && !controller.isLoading.value) {
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

  AppBar _appBar(BuildContext context) => AppBar(
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title: const Text("Events"),
    leading: IconButton(
      icon: const Icon(Icons.logout),
      hoverColor: Colors.blueAccent,
      tooltip: "Press To Logout",
      color: Colors.white,
      onPressed: controller.logout,
    ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.language_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed:controller.onChangeLanguage,
        )
      ]
  );

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
                  itemCount: controller.events.length,
                  itemBuilder: (_, index) => EventsWidget(
                    event: controller.events[index],
                    onBookmark: () => controller.toggleBookmark(
                      controller.events[index].id,
                    ),
                    onTap: (controller.events[index].filled ||
                        controller.events[index].date
                            .isBefore(DateTime.now()))
                        ? controller.filledEvent
                        : () => controller.goToEvent(
                      controller.events[index].id,
                    ),
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
