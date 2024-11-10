import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/events_controller.dart';
import 'widgets/events_widget.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _appBar(),
      body: Obx(() => _body()),
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
        icon: const Icon(Icons.change_circle),
      ),
    );
  }

  AppBar _appBar() =>
      AppBar(centerTitle: true, title: const Text("home page"),
          actions: const [
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        )
      ]);

  Widget _success() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.events.length,
            itemBuilder: (_, index) => EventsWidget(
              event: controller.events[index],
              // onTap: () => controller.goToEvent(index)
              onTap: () {},
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      );
}
