import 'package:flutter/material.dart';


class Textos extends StatelessWidget {
final String meuTexto;
final Color cores;


const Textos(this.meuTexto, this.cores, {super.key});


@override
Widget build(BuildContext context) {
return Text(
meuTexto,
style: TextStyle(color: cores, fontSize: 20),
);
}
}