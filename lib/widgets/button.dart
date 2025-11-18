import 'package:flutter/material.dart';

class Botoes extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icone;

  const Botoes(this.texto, {required this.onPressed, this.icone, super.key});

  @override
  Widget build(BuildContext context) {
    if (icone != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(texto),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(texto),
    );
  }
}