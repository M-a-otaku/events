import 'package:flutter/material.dart';
import '../../model/car.dart';
import 'package:get/get.dart';

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
          label: Text( isDescending ? "Descending" : "ascending" ) ,
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
  void toggle(){
    isDescending = !isDescending;
  }
}

