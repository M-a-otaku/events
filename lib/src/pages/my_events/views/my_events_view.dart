import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_events_controller.dart';
import 'widgets/my_events_widget.dart';

class MyEventsView extends GetView<MyEventsController> {
  const MyEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      // floatingActionButton: Hero(
      //   tag: Obx(() => _fab()),
      //   child: Obx(() => _fab()),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: _appBar(),
      body: RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: Obx(() => _body())),
    );
  }

  Widget _body() {
    if (controller.isLoading.value) {
      return _loading();
    } else if (controller.isRetry.value) {
      return _retry();
    } else if (controller.myEvents.isEmpty) {
      return const Center(
        child: Text(
          "list is empty",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
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
        onPressed: controller.getEvents,
        icon: const Icon(Icons.change_circle),
      ),
    );
  }

  AppBar _appBar() =>
      AppBar(centerTitle: true, title: const Text("My Events"), actions: const [
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        )
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
              event: controller.myEvents[index],
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      );
}
