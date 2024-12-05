import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaReproductor.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

class PaginaDocumentacion extends StatefulWidget {
  const PaginaDocumentacion({super.key});

  @override
  _PaginaDocumentacionState createState() => _PaginaDocumentacionState();
}

class _PaginaDocumentacionState extends State<PaginaDocumentacion> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle miEstiloMenuItem = TextStyle();
  TextStyle miEstiloMenuSubTitulo = TextStyle();
  double heigthIconoMenuItem = 0;
  Datos misDatos = Datos();

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    heigthIconoMenuItem = responsive.diagonalPorc(4);
    miEstiloMenuItem = TextStyle(color: miColorBotones, fontSize: responsive.diagonalPorc(2.5));
    miEstiloMenuSubTitulo = TextStyle(fontSize: responsive.diagonalPorc(1.5));

    return Scaffold(
        key: scaffoldKey,
        appBar: dameAppBar(titulo: "DOCUMENTACION", fontSize: responsive.diagonalPorc(3)),
        body: ListView(children: <Widget>[
          Divider(),
          ListTile(
            title: Text("Manual APP", style: miEstiloMenuItem),
            subtitle: Text(
              "Muestra un documento donde se explica como utilizar la app",
              style: miEstiloMenuSubTitulo,
            ),
            leading: Icon(
              Icons.menu_book,
              size: heigthIconoMenuItem,
              color: miColorBotones,
            ),
            onTap: () async {
              try {
                String ruta = misDatos.usuario.rutaDocumentacionAPP;

                getFileFromUrl(ruta, "ManualAPP.pdf").then((f) {
                  if (f.existsSync() == true) {
                    OpenFile.open(f.path);
                  } else {
                    mostrarMensaje(true, 'No se ha podido descargar el fichero');
                  }
                });
              } catch (e) {
                //mostrarMensaje(true, e.message);
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Errores Impresora", style: miEstiloMenuItem),
            subtitle: Text(
              "Muestra el significado de los errores mas comunes en la impresora",
              style: miEstiloMenuSubTitulo,
            ),
            leading: Icon(
              Icons.error_outline,
              size: heigthIconoMenuItem,
              color: miColorBotones,
            ),
            onTap: () {
              try {
                String ruta = misDatos.usuario.rutaDocumentacionAPP;

                getFileFromUrl(ruta, "ErroresImpresora.png").then((f) {
                  if (f.existsSync() == true) {
                    OpenFile.open(f.path);
                  } else {
                    mostrarMensaje(true, 'No se ha podido descargar el fichero');
                  }
                });
              } catch (e) {
                // mostrarMensaje(true, e.message);
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Cambiar rollos impresora", style: miEstiloMenuItem),
            subtitle: Text(
              "Muestra como cambiar los rollos RIBBON y de ETIQUETAS de la imprsora",
              style: miEstiloMenuSubTitulo,
            ),
            leading: Icon(
              Icons.panorama_fish_eye,
              size: heigthIconoMenuItem,
              color: miColorBotones,
            ),
            onTap: () {
              try {
                String ruta = misDatos.usuario.rutaDocumentacionAPP;

                getFileFromUrl(ruta, "CambioRollosImpresora.pdf").then((f) {
                  if (f.existsSync() == true) {
                    OpenFile.open(f.path);
                  } else {
                    mostrarMensaje(true, 'No se ha podido descargar el fichero');
                  }
                });
              } catch (e) {
                // mostrarMensaje(true, e.message);
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Calibrar la impresora", style: miEstiloMenuItem),
            subtitle: Text(
              "Muestra un video de como calibrar la impresora",
              style: miEstiloMenuSubTitulo,
            ),
            leading: Icon(
              Icons.memory,
              size: heigthIconoMenuItem,
              color: miColorBotones,
            ),
            onTap: () {
              try {
                String ruta = misDatos.usuario.rutaDocumentacionAPP;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaginaReproductor(
                              sRutaVideo: "$ruta/CalibracionZT220.mp4",
                            )));
              } catch (e) {
                // mostrarMensaje(true, e.message);
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Eliminar atasco rodillo", style: miEstiloMenuItem),
            subtitle: Text(
              "Muestra un video de como eliminar el atasco de etiquetas sobre el rodillo",
              style: miEstiloMenuSubTitulo,
            ),
            leading: Icon(
              Icons.video_settings,
              size: heigthIconoMenuItem,
              color: miColorBotones,
            ),
            onTap: () {
              try {
                String ruta = misDatos.usuario.rutaDocumentacionAPP;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaginaReproductor(
                              sRutaVideo: "$ruta/CambioRodilloZT220.mp4",
                            )));
              } catch (e) {
                // mostrarMensaje(true, e.message);
              }
            },
          ),
          Divider()
        ]));
  }
}
