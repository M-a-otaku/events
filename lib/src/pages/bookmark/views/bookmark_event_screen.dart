import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../controllers/bookmark_event_controller.dart';
import 'widgets/bookmark_event_widget.dart';

class BookmarkEventScreen extends GetView<BookmarkEventController> {
  const BookmarkEventScreen({super.key});

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
    );
  }

  Widget _body(BuildContext context) {
    if (controller.isRetry.value) {
      return _retry();
    }
    if (controller.bookmarkedEvents.isEmpty && !controller.isLoading.value) {
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
            onPressed: controller.getBookmarked,
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
    backgroundColor: Colors.blueAccent,
    centerTitle: true,
    title:  Text(LocaleKeys.bookmarked_Events_bookmarked_events.tr),
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

  Widget _success(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
    child: Column(
      children: [
        // Row for filter and search
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.blue),
              tooltip:LocaleKeys.filter_Dialog_sort_filter.tr,
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
                  labelText:LocaleKeys.event_page_search.tr,
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

        // Stack for loading or list
        Expanded(
          child: Stack(
            children: [
              // ListView for events
              if (!controller.isLoading.value)
                ListView.separated(
                  itemCount: controller.bookmarkedEvents.length,
                  itemBuilder: (_, index) => BookmarkEventWidget(
                    event: controller.bookmarkedEvents[index],
                    onBookmark: () => controller.toggleBookmark(
                      eventId: controller.bookmarkedEvents[index].id,
                    ),
                    // onTap: (controller.bookmarkedEvents[index].filled ||
                    //     controller.bookmarkedEvents[index].date.isBefore(DateTime.now()))
                    //     ? controller.filledEvent
                    //     : () => controller.goToEvent(
                    //     controller.bookmarkedEvents[index].id),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),

              // CircularProgressIndicator for loading
              if (controller.isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
