import 'package:flutter/material.dart';

class Textfont extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final bool bold;
  const Textfont(
      {super.key,
      required this.text,
      required this.color,
      required this.size,
      required this.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color),
    );
  }
}
