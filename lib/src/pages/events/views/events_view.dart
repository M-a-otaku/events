import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/events_controller.dart';
import 'widgets/events_widget.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
        icon: const Icon(Icons.reset_tv),
        iconSize: 35,
      ),
    );
  }

  AppBar _appBar(context) => AppBar(
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
      );

  Widget _success(context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
    child: Obx(
          () => Stack(
        children: [
          // محتوای اصلی صفحه
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),
              ),
            ],
          ),
          // نمایش لودینگ در مرکز صفحه
          if (controller.isLoading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    ),
  );
}
