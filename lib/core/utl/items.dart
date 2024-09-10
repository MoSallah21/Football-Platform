import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.text,
    this.icon,
  });

  final String text;
  final Image? icon;
}

