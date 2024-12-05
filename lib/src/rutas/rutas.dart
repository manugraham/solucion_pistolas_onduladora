import 'package:flutter/material.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaColocarBobina.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaConfiguracion.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaConsultarBobina.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaDocumentacion.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaElegirBobinas.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaRecuperarBobinasGrupo.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaReimprimirEtiquetas.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaRetirarBobina.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaRetirarBobinaRadio.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/paginaHome.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/splashScreen.dart';

Map<String, WidgetBuilder> dameRutasAplicacion() {
  return <String, WidgetBuilder>{
    '/RetirarBobina': (BuildContext context) => PaginaRetirarBobina(),
    '/ConsultarBobina': (BuildContext context) => PaginaConsultarBobina(),
    '/ColocarBobina': (BuildContext context) => PaginaColocarBobina(),
    '/Home': (BuildContext context) => PaginaHome(),
    '/': (BuildContext context) => SplashScreenAPP(),
    '/RecuperarBobina': (BuildContext context) => PaginaReucperarBobinasGrupo(), //new PaginaRecuperarBobina(),
    '/ReimprimirEtiqueta': (BuildContext context) => PaginaReimprimirEtiqutas(),
    '/RetirarBobinaRadio': (BuildContext context) => PaginaRetirarBobinaRadio(),
    '/Configuracion': (BuildContext context) => PaginaConfiguracion(),
    '/BobinasEnPulmon': (BuildContext context) => PaginaElegirBobinas(),
    '/Documentacion': (BuildContext context) => PaginaDocumentacion(),
    //'/Facturas': (BuildContext context) =>PaginaFacturas(),
    //'/Ficheros': (BuildContext context) =>PaginaFicheros(),
    //'/Pedidos': (BuildContext context) =>PaginaPedidos(),
    /*'animatedContainer' : (BuildContext context) => AnimatedContainerPage(),*/
  };
}
