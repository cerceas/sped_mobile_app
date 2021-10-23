import 'package:flutter/material.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    required this.date,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  String date;
  bool isExpanded;
}

