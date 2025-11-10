import 'package:flutter/material.dart';


class Botoes extends StatelessWidget {
  final String texto;
  final void Function() onPressed;


  const Botoes(this.texto, {required this.onPressed, super.key});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(texto));
  }
}