import 'dart:convert';

import 'package:events/src/pages/my_events/controllers/my_events_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/my_events_model.dart';

class EventsScreen2 extends GetView<MyEventsController> {
  const EventsScreen2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black12,
        title: const Text(
          "suiiiii",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: controller.myEvents.isEmpty
          ? Center(
              child: Text("nothing"),
            )
          : ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              shrinkWrap: true,
              itemCount: controller.myEvents.length,
              itemBuilder: (context, index) {
                final event = controller.myEvents[index];
                return GestureDetector(
                  onTap: () {
                    // برای هدایت به صفحه جزئیات
                    // Navigator.push(
                    //   context
                    //   // MaterialPageRoute(
                    //   //   // builder: (context) => EventDetailScreen(event),
                    //   // ),
                    // );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 24, right: 24, top: 50),
                          padding: const EdgeInsets.only(
                              left: 25, bottom: 15, right: 20, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueAccent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${event.price.toString()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Hero(
                                    tag: 'hero_${event.id}',
                                    child: (event.image != null &&
                                            event.image!.isNotEmpty)
                                        ? ClipOval(
                                            child: Image.memory(
                                                base64Decode(event.image!)))
                                        : const Icon(Icons.event,
                                            color: Colors.white),
                                  ),
                                ],
                              ),
                              const Text(
                                "price",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CarItems(name: "title", value: event.title),
                                  CarItems(
                                      name: "date",
                                      value: event.date.toString()),
                                  CarItems(
                                      name: "capacity",
                                      value: event.capacity.toString()),
                                  CarItems(
                                      name: "description",
                                      value: event.description.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<MyEventsModel> searchTerms = []; // Initialize this with your event list

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<MyEventsModel> matches = searchTerms
        .where(
            (event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        var result = matches[index];
        return ListTile(
          title: Text(result.title),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<MyEventsModel> matches = searchTerms
        .where(
            (event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        var result = matches[index];
        return ListTile(
          title: Text(result.title),
        );
      },
    );
  }
}

class CarItems extends GetView<MyEventsController> {
  const CarItems({
    required this.name,
    required this.value,
    this.textColor = Colors.white,
    super.key,
  });

  final String name, value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
