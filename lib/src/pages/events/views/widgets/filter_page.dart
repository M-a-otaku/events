import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/events_controller.dart';

class FilterPage extends StatelessWidget {
  final EventsController controller = Get.find();

   FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              controller.filterEvents();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              decoration: const InputDecoration(labelText: 'Filter by Title'),
              onChanged: (value) {
                controller.selectedTitleFilter = value;
              },
            ),
            const SizedBox(height: 10),


            TextField(
              decoration: const InputDecoration(labelText: 'Filter by Date'),
              onChanged: (value) {
                controller.selectedDateFilter = value;
              },
            ),
            const SizedBox(height: 10),


            TextField(
              decoration: const InputDecoration(labelText: 'Filter by Capacity'),
              onChanged: (value) {
                controller.selectedCapacityFilter = value;
              },
            ),
            const SizedBox(height: 10),


            SwitchListTile(
              title: const Text('Show Only Filled Events'),
              value: controller.isFilledFilter,
              onChanged: (value) {
                controller.isFilledFilter = value;
              },
            ),
            const SizedBox(height: 20),


            ElevatedButton(
              onPressed: () {
                controller.filterEvents();
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
