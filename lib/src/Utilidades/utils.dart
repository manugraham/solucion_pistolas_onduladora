import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as AES;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solucion_pistolas_onduladora/main.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/ficherosAntiguos/excepciones.dart';
import 'package:intl/intl.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';
import 'package:http/http.dart' as http;

final int segundosMinimosConexion = 300;
final String sNombreAPP = 'pistolaBobinas';
final Color miColorGris = Color.fromARGB(-17, 199, 199, 199);
final Color miColorFondo = Color.fromARGB(-17, 235, 70, 50);
final Color miColorBotones = Color.fromARGB(-10, 28, 28, 28);

final apiKey = "ondupackondupets";
final apiIV = "rpaSPvIvVLlrcmtz";

final miFormatoDouble = NumberFormat("###.0#", "es_ES");
final miFormatoEntero = NumberFormat("#,##0", "es_ES");
//double heigthIconoMenuItem = 25.0;

final miEstiloMenuCabecera = TextStyle(color: miColorBotones, fontSize: 25, backgroundColor: miColorGris);
final miEstiloCabeceraPagina = TextStyle(
  color: miColorBotones,
  fontSize: 15,
);

final miEstiloTextFormField = TextStyle(fontSize: 20.0);
final miEstiloTextNormal = TextStyle(fontSize: 20.0, color: miColorBotones);
final miEstiloTextButton = TextStyle(fontSize: 15.0, color: miColorBotones);

const String tipoCodigoServicioCorrecto = "0";
const String tipoCodigoServicioSesionCaducada = "1";
const String tipoCodigoServicioError = "2";
const String tipoCodigoServicioSinConexion = "-1";

//maximos
final int maximoCaracteresGRUPO = 3;
final int maximoCaracteresCodigoBarras = 8;

//minimos
final int minimoCaracteresRadio = 2;

enum OpcionesElegirBobinas { BobinasEnPulmon, BobinasConsumidasGrupo, BobinasRecuperadasGrupo }

enum OpcionesFocus { Grupo, CodigoBarras, Radio }

enum OpcionesInterfaz { Ninguna, ColocarBobina, RetirarBobina, RecuperarUltimaBobina, ConsultarBobina, RetirarBobinaCompleta, ReimprimirEtiqueta, RetirarBobinaRadio, Manuales, ErroresImpresora, CalibrarImpresora, CambiosRodillosImpresora }

String encryptar(String texto) {
  try {
    if (texto.trim().isNotEmpty) {
      final key = AES.Key.fromUtf8(apiKey); //.fromLength(32);
      final iv = AES.IV.fromUtf8(apiIV);
      final encrypter = AES.Encrypter(AES.AES(key, mode: AES.AESMode.cbc));

      texto = encrypter.encrypt(texto.trim(), iv: iv).base64;
      texto = Uri.encodeComponent(texto).replaceAll('%', '-');
    }

    return texto;
  } catch (error) {
    throw TipoError("-2", error.toString());
  }
}

String desencryptar(String texto) {
  try {
    final key = AES.Key.fromUtf8(apiKey); //.fromLength(32);
    final iv = AES.IV.fromUtf8(apiIV);
    final encrypter = AES.Encrypter(AES.AES(key, mode: AES.AESMode.cbc));

    texto = texto.replaceAll('-', '%');
    texto = Uri.decodeComponent(texto);

    texto = encrypter.decrypt64(texto, iv: iv);

    return texto;
  } catch (error) {
    throw TipoError("-2", error.toString());
  }
}

void mostrarNotificacion(BuildContext context, String titulo, String mensaje) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
      );
    },
  );
}

Future<void> descargarFichero(String ruta, String nombreFichero) async {
  Dio dio = Dio();
  var dir = await getApplicationDocumentsDirectory();

  try {
    await dio.download(ruta, "${dir.path}/$nombreFichero", onReceiveProgress: (rec, total) {
      print("Rec: $rec , Total: $total");
    });
  } catch (e) {
    print(e);
  }

  OpenFile.open("${dir.path}/$nombreFichero");

  print("Descarga completada");
}

Future<File> getFileFromUrl(String url, String nombreFichero) async {
  try {
    var data = await http.get(('$url/$nombreFichero') as Uri);
    var bytes = data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();

    File file = File("${dir.path}/$nombreFichero");

    file.writeAsBytesSync(bytes, mode: FileMode.write, flush: true);

    return file;
  } catch (e) {
    throw Exception("Error al abrir el archivo");
  }
}

void comprobarTipoError(BuildContext context, HttpError error) {
  switch (error.codigo.toString()) {
    case tipoCodigoServicioSesionCaducada:
      {
        RestartWidget.restartApp(context);
      }
      break;
    case tipoCodigoServicioSinConexion:
      {
        Datos misDatos = Datos();
        misDatos.volverAConectar();
        Navigator.pushNamed(context, "/Home");
      }
      break;
    default:
      {}
      break;
  }
  if (error.codigo == tipoCodigoServicioSesionCaducada.toString()) {
    RestartWidget.restartApp(context);
  }
}

void ocultarTeclado(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

Widget textBox(String texto, double sizeText) {
  return Container(
    padding: EdgeInsets.all(2),
    margin: EdgeInsets.fromLTRB(0, 2, 2, 2),
    decoration: BoxDecoration(border: Border.all(color: miColorBotones)),
    child: Flexible(
      child: Text(texto, style: TextStyle(fontSize: sizeText), overflow: TextOverflow.ellipsis),
    ),
  );
}

Widget labelBox(String textoCabecera, String texto, double ancho, double sizeText, Alignment alineacion) {
  return Container(
    // width: ancho,
    child: Row(children: <Widget>[
      SizedBox(width: 65, child: RichText(text: TextSpan(text: textoCabecera, style: TextStyle(fontWeight: FontWeight.bold, color: miColorBotones, fontSize: sizeText)))),
      SizedBox(
        width: 5,
      ),
      Container(width: ancho, alignment: alineacion, color: Colors.black, child: Flexible(child: Text(texto, style: TextStyle(color: Colors.green, fontSize: sizeText), overflow: TextOverflow.ellipsis))),
      SizedBox(
        width: 5,
      ),
    ]),
  );
}

String pasarSegundosAHoras(int segundos) {
  try {
    String sHoras;
    String sMinutos;
    String sSegundos;

    int iMinutos;
    int iHoras;
    int iSegundos;
    int iSegundosHora = 3600;

    iHoras = (segundos ~/ iSegundosHora).round();
    iMinutos = ((segundos % iSegundosHora) ~/ 60).round();
    iSegundos = ((segundos % iSegundosHora) % 60);

    if (iHoras < 10) {
      sHoras = '0$iHoras';
    } else {
      sHoras = iHoras.toString();
    }

    if (iMinutos < 10) {
      sMinutos = '0$iMinutos';
    } else {
      sMinutos = iMinutos.toString();
    }

    if (iSegundos < 10) {
      sSegundos = '0$iSegundos';
    } else {
      sSegundos = '0$iSegundos';
    }

    return "$sHoras:$sMinutos:$sSegundos";
  } catch (err) {
    return "00:00:00";
  }
}

String formatearEntero(int numero) {
  List<String> parts = numero.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, '.');

  return parts[0];
}

String formatearDecimales(double numero) {
  List<String> parts = numero.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, '.');
  if (parts.length == 1) {
    parts.add('00');
  } else {
    parts[1] = parts[1].padRight(2, '0').substring(0, 2);
  }
  return parts.join(',');
}

AppBar dameAppBar({String? titulo, double? fontSize}) {
  return AppBar(
    title: Text(
      titulo!,
      style: TextStyle(color: miColorBotones, fontSize: fontSize),
    ),
    backgroundColor: miColorFondo,
    iconTheme: IconThemeData(color: miColorBotones),
  );
}

SnackBar dameSnackBar({String? titulo, bool? error}) {
  Color miColor = Colors.red;
  if (error == false) {
    miColor = Colors.blueGrey;
  }
  return SnackBar(
      backgroundColor: miColor,
      content: SizedBox(
          height: 50.0,
          child: Text(
            titulo!,
            style: TextStyle(fontSize: 20),
          )));
}
