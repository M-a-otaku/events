
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailsDto {
  int participants ;
  bool filled ;

  EventDetailsDto({
    required this.filled,
    required this.participants,
  });

Map<String, dynamic> toJson() => {
        "filled": filled,
        "participants": participants,

      };
}
