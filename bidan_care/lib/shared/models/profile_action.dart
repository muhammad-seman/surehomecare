import 'package:flutter/material.dart';

class ProfileAction {
  final IconData icon;
  final String title;
  final Function() onPressed;

  const ProfileAction({
    required this.icon,
    required this.title,
    required this.onPressed,
  });
}
