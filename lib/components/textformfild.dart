import 'package:flutter/material.dart';

class CustomTextFormFild extends StatelessWidget {
  final String? Function(String?)? validator;
  final String hint;
  final Widget prefixIcon;

  final TextEditingController controller;
  const CustomTextFormFild(
      {super.key,
      required this.hint,
      required this.controller,
      this.validator,
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 245, 245, 245))),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.black54),
          fillColor: const Color.fromARGB(255, 245, 245, 245),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 245, 245, 245)))),
    );
  }
}
