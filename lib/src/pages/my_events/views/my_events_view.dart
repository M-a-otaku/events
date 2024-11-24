import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
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
      appBar: _appBar(context),
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
          Text(
            LocaleKeys.event_page_retry.tr ,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          IconButton(
            tooltip: LocaleKeys.event_page_refresh.tr,
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
                  tooltip: LocaleKeys.filter_Dialog_sort_filter.tr,
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
                      labelText: LocaleKeys.event_page_search.tr,
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

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  LocaleKeys.event_page_empty.tr,
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

  AppBar _appBar(context) => AppBar(
    centerTitle: true,
    title:  Text(LocaleKeys.bottom_nav_bar_my_events.tr),
    backgroundColor: Colors.blueAccent,
    leading: IconButton(
      icon: const Icon(Icons.logout),
      hoverColor: Colors.grey,
      tooltip: LocaleKeys.event_page_logout_press.tr,
      color: Colors.white,
      onPressed: () =>controller.showLogoutDialog(context),
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.language_outlined,
          color: Colors.white,
          size: 24,
        ),
        hoverColor: Colors.grey,
        tooltip: LocaleKeys.event_page_change_language.tr ,
        onPressed: controller.onChangeLanguage,
      )
    ],
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
                    tooltip: LocaleKeys.filter_Dialog_sort_filter.tr ,
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
                        labelText: LocaleKeys.event_page_search.tr,
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
                      onTap: (controller.isEventRemoving[controller.myEvents[index].id] ?? false)
                          ? null
                          : () => controller.toEditPage(
                        eventId: controller.myEvents[index].id,
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
