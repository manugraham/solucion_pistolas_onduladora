import 'package:flutter/material.dart';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/paginaHome.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';

class SplashScreenAPP extends StatefulWidget {
  const SplashScreenAPP({super.key});

  @override
  _SplashScreenAPPState createState() => _SplashScreenAPPState();
}

class _SplashScreenAPPState extends State<SplashScreenAPP> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [miColorGris, miColorFondo],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: FlutterSplashScreen.fadeIn(
        backgroundColor: Colors.white,
        onInit: () {
          debugPrint("On Init");
        },
        onEnd: () {
          debugPrint("On End");
        },
        childWidget: SizedBox(
          height: 200,
          width: 200,
          // child: Image.asset("imagenes/ONDUPACK.png"),
          child: Image.asset("imagenes/logo_color.png"),
        ),
        onAnimationEnd: () => debugPrint("On Fade In End"),
        nextScreen: PaginaHome(),
      ),
    );
  }
}
