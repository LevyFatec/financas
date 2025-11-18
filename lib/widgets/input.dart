import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const Input(
      this.label, {
        required this.controller,
        this.hint,
        this.keyboardType = TextInputType.text,
        this.validator,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}