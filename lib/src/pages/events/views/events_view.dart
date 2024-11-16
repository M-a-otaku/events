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

  AppBar _appBar() =>
      AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: Text("home"),
          leading: IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white, onPressed: controller.logout,
          ),
          actions: const [
            Icon(
              Icons.menu,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            )
          ]);

  Widget _success() =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Obx(
              () =>
              ListView.separated(
                itemCount: controller.events.length,
                itemBuilder: (_, index) =>
                    EventsWidget(
                        event: controller.events[index], onBookmark: () =>
                        controller.toggleBookmark(controller.events[index].id),
                      onTap: () => controller.goToEvent(controller.events[index].id)
                      // onTap: () {},
                    ),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
        ),
      );
}
