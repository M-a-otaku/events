import 'package:events/src/pages/EEvents/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/car.dart';
import '../model/event_model.dart';
import 'Detail/car_detail_screen.dart';
import 'widgets/events_widgets.dart';

class EventsScreen extends GetView<EventController> {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black12,
        title: const Text(
          "Home Page",
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
              icon: const Icon(Icons.search)),
        ],
      ),
      body: ListView.builder(
            shrinkWrap: true,
            itemCount: carList.length,
            itemBuilder: (context, index) {
              final car = carList[index];
              return GestureDetector(
                onTap: () {
                  // for navigating
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarDetailScreen(car)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 24, right: 24, top: 50),
                        padding: const EdgeInsets.only(
                            left: 25, bottom: 15, right: 20, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$${car.price.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "price/hr",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CarItems(name: "Brand", value: car.brand),
                                CarItems(name: "Model No", value: car.model),
                                CarItems(name: "CO2", value: car.co2),
                                CarItems(name: "Fule Cons", value: car.fuelCons),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 30,
                        child: Hero(
                          tag: car.image,
                          child: Image.asset(
                            car.image,
                            height: 115,
                          ),
                        ),
                      )
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
  List<Car> searchterms = carList;
  bool isDescending = false;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Car> match = [];
    for (var car in searchterms) {
      if (car.toString().toLowerCase().contains(query.toLowerCase())) {
        match.add(car);
      }
    }
    return ListView.builder(
        itemCount: match.length,
        itemBuilder: (context, index) {
          var result = match[index];
          return Column(
            children: [
              Icon(Icons.arrow_upward),
              ListTile(
                title: Text("$result"),
              ),
            ],
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Car> match = [];
    for (var car in searchterms) {
      if (car.toString().toLowerCase().contains(query.toLowerCase())) {
        match.add(car);
      }
    }
    return Column(
      children: [
        TextButton.icon(
          onPressed: toggle,
          label: Text(isDescending ? "Descending" : "ascending"),
          icon: RotatedBox(quarterTurns: 1, child: Icon(Icons.compare_arrows)),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: match.length,
              itemBuilder: (context, index) {
                var result = match[index];
                return ListTile(
                  title: Text("$result"),
                );
              }),
        ),
      ],
    );
  }

  void toggle() {
    isDescending = !isDescending;
  }
}
