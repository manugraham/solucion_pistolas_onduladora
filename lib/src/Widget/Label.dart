import 'package:flutter/material.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';

class Label extends StatelessWidget {
  final String label;
  final String valor;
  final Color colorLabel;
  final double fontSize;
  final double ancho;

  const Label({super.key, required this.label, required this.colorLabel, required this.fontSize, required this.valor, required this.ancho});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontSize: fontSize, color: colorLabel, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(fontSize: fontSize, color: miColorBotones),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
