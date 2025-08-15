import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> small = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 5,
      color: Colors.black12,
    ),
  ];
  static const List<BoxShadow> medium = [
    BoxShadow(
      offset: Offset(0, 5),
      blurRadius: 10,
      color: Colors.black12,
    ),
  ];
}
