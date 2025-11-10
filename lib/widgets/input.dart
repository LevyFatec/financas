import 'package:flutter/material.dart';


class Input extends StatelessWidget {
  final String rotulo;
  final String label;
  final TextEditingController controller;


  const Input(this.rotulo, this.label, {required this.controller, super.key});


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: rotulo, hintText: label),
    );
  }
}