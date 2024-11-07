import 'package:flutter/material.dart';

class CustomMaterailButoon extends StatelessWidget {
  final Widget child;
  final Color color;
  final void Function()? onPressed;
  const CustomMaterailButoon(
      {super.key, required this.color, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: color,
      minWidth: double.infinity,
      height: 55,
      onPressed: onPressed,
      child: child,
    );
  }
}
