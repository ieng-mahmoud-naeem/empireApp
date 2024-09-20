import 'package:flutter/material.dart';

class Cardmodel {
  final List<Color> colors;
  final String text;
  final Widget onTap;

  Cardmodel({
    required this.colors,
    required this.text,
    required this.onTap,
  });
}
