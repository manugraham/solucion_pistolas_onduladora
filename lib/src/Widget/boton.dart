import 'package:flutter/material.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';

// ignore: must_be_immutable
class Boton extends StatelessWidget {
  final double ancho;
  final double alto;
  final String texto;
  Function pAccion;

  Boton({super.key, required this.texto, required this.pAccion, required this.ancho, required this.alto})
      : assert(texto.trim().isNotEmpty),
        assert(alto > 0),
        assert(ancho > 0);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return TextButton(
      onPressed: () {
        pAccion();
      },
      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(ancho, alto), alignment: Alignment.centerLeft),
      /*style: ButtonStyle(        
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide(color: miColorFondo))),
      ),*/
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          decoration: BoxDecoration(color: miColorFondo, borderRadius: BorderRadius.circular(0), boxShadow: [BoxShadow(color: miColorBotones, blurRadius: 0), BoxShadow()]),
          alignment: Alignment.center,
          width: (ancho),
          height: (alto),
          child: Text(
            texto,
            style: TextStyle(fontSize: responsive.diagonalPorc(1.5), color: miColorBotones),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      //padding: EdgeInsets.all(0.0),
    );
  }
}
