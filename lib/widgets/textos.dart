import 'package:flutter/material.dart';

class Textos extends StatelessWidget {
  final String texto;
  final Color? cor;
  final double? tamanho;
  final FontWeight? peso;
  final TextAlign? align;

  const Textos(
      this.texto, {
        super.key,
        this.cor,
        this.tamanho,
        this.peso,
        this.align,
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Se não passar cor, usa a cor padrão do texto do tema
    return Text(
      texto,
      textAlign: align,
      style: TextStyle(
        color: cor ?? theme.textTheme.bodyLarge?.color,
        fontSize: tamanho ?? 16,
        fontWeight: peso ?? FontWeight.normal,
      ),
    );
  }
}