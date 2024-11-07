import 'package:flutter/material.dart';

class Sps extends StatelessWidget {
  final double height;
  const Sps({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
