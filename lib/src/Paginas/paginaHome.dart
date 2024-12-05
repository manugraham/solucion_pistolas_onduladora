import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/boton.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/Http.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Maquina.dart';
//import 'package:get_version/get_version.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Sesion.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Sistema.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({super.key});

  @override
  _PaginaHomeState createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool? bDescargaFichero = false;
  String? sImpresoraSeleccionada;
  int? iMaquinaSeleccionada = 0;
  bool? bConectando = false;
  String? sVersion = "";
  String? sCodigoVersion = "";
  OpcionesInterfaz? iOpcionEscogida = OpcionesInterfaz.Ninguna;
  Datos misDatos = Datos();
  List<String>? misImpresoras;
  List<Maquina>? misMaquinas;
  bool downloading = false;
  var progressString = "";
  BBDD? _miBBDD;
  Sistema? miSistema;
  double? heigthIconoMenuItem;
  TextStyle? miEstiloMenuItem;
  TextStyle? miEstiloMenuSubTitulo;

  _PaginaHomeState() {
    conectar();
    construirVersionAPP();
  }

  Future<void> cargarSistema() async {
    miSistema = Sistema(nombre: '', url: '', usuario: '', clave: '');

    if (!GetIt.instance.isRegistered<Sistema>()) {
      GetIt.instance.registerSingleton<Sistema>(miSistema!);
    }

    miSistema = GetIt.instance<Sistema>();

    await miSistema!.fromSecure();

    if (miSistema!.url.isNotEmpty) {
      final Dio dio = Dio(BaseOptions(baseUrl: miSistema!.url));

      Http http = Http(
        dio: dio,
        //logsEnabled: true,
      );

      _miBBDD = BBDD(http);
      //sino esta registrado entonces los registramos
      if (!GetIt.instance.isRegistered<BBDD>()) {
        GetIt.instance.registerSingleton(_miBBDD!);
      }
    } else {
      miSistema = Sistema(nombre: '', url: '', usuario: '', clave: '');
    }
  }

  void conectar() async {
    await cargarSistema();
    setState(() {
      bConectando = true;
    });

    //SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    misDatos.volverAConectar();

    if (miSistema!.url.trim().isNotEmpty) {
      if (misDatos.usuario.creado == false) {
        //final RespuestaHTTP<Sesion> misDatosSesion = await _miBBDD.login(usuario: miConfiguracion.getString("Usuario"), clave: miConfiguracion.getString("Clave"));
        final RespuestaHTTP<Sesion> miRespuesta = await _miBBDD!.login(usuario: miSistema!.usuario, clave: miSistema!.clave);

        Sesion miSesion;

        if (!GetIt.instance.isRegistered<Sesion>()) {
          //hacemos de la sesion que sea singleton
          GetIt.instance.registerSingleton<Sesion>(miRespuesta.data!);
        }

        miSesion = GetIt.instance<Sesion>();
        miSesion.token = miRespuesta.data!.token;
        miSesion.saveSession();

        final RespuestaHTTP miUsuario = await _miBBDD!.dameInformacionUsuario();

        if (miUsuario.data != null) {
          if (bDescargaFichero == false) {
            misDatos.setUsuario(miUsuario.data);

            misImpresoras = misDatos.usuario.getImpresoras;
            misMaquinas = misDatos.usuario.getMaquinas;

            comprobarImpresora();
            comprobarMaquina();

            mostrarMensaje(false, "Sesion iniciada correctamente");

            setState(() {});

            if (sCodigoVersion != "") {
              if (misDatos.usuario.versionAPPActual! > 0) {
                if (misDatos.usuario.versionAPPActual! > int.parse(sCodigoVersion!)) {
                  actualizar();
                }
              }
            }
          }
        } else {
          mostrarMensaje(true, "${miUsuario.error!.codigo} - ${miRespuesta.error!.mensaje!}");
        }

        setState(() {
          bConectando = false;
        });
      }
    } else {
      setState(() {
        bConectando = false;
      });
    }
  }
  /* void conectar() async {
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    if (misDatos.usuario.creado == false) {
      bCargandoUsuario = false;
      miInterface.login(miConfiguracion.getString("Usuario"), miConfiguracion.getString("Clave"));
    }
  }*/

  void construirVersionAPP() async {
    /* String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetVersion.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }*/

    String projectVersion = "16";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /************************************** aqui hay que coger la version ****************************/
      // projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /************************************** aqui hay que coger la version ****************************/
      //sCodigoVersion = await GetVersion.projectCode;
    } on PlatformException {
      sCodigoVersion = "16";
      mostrarMensaje(true, "No se ha podido recuperar la version de la app.");
    }

    /* String projectAppID;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectAppID = await GetVersion.appID;
    } on PlatformException {
      projectAppID = 'Failed to get app ID.';
    }

    String projectName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectName = await GetVersion.appName;
    } on PlatformException {
      projectName = 'Failed to get app name.';
    }*/

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      sVersion = '$projectVersion.${sCodigoVersion!}';
    });
  }

  void comprobarMaquina() async {
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    int? iMaquinaPorDefecto = miConfiguracion.getInt("Maquina");

    iMaquinaPorDefecto ??= 10;

    if (iMaquinaPorDefecto > 0) {
      if (misMaquinas!.isNotEmpty) {
        if (misMaquinas!.where((element) => element.codigo == iMaquinaPorDefecto).isEmpty) {
          iMaquinaSeleccionada = misMaquinas!.first.codigo;
        } else {
          iMaquinaSeleccionada = iMaquinaPorDefecto;
        }
      }

      setState(() {
        misDatos.usuario.setMaquinaSeleccionada(iMaquinaSeleccionada);
      });
    }
  }

  void comprobarImpresora() async {
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    String? sImpresoraPorDefecto = miConfiguracion.getString("Impresora");

    sImpresoraPorDefecto ??= "";

    if (sImpresoraPorDefecto.trim().isNotEmpty) {
      if (misImpresoras!.isNotEmpty) {
        if (misImpresoras!.where((element) => element == sImpresoraPorDefecto).isEmpty) {
          sImpresoraSeleccionada = misImpresoras!.first;
        } else {
          sImpresoraSeleccionada = sImpresoraPorDefecto;
        }
      }

      setState(() {
        misDatos.usuario.setImpresoraSeleccionada(sImpresoraSeleccionada!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    heigthIconoMenuItem = responsive.diagonalPorc(3);
    miEstiloMenuItem = TextStyle(color: miColorBotones, fontSize: responsive.diagonalPorc(2.5));
    miEstiloMenuSubTitulo = TextStyle(fontSize: responsive.diagonalPorc(1.5));

    // RaisedButton cmdReconectar = botonWidget(context, "RECONECTAR", pAccion: () => {conectar()});

    //WillPopScope evita que salga el boton atras en la pantalla indicada.
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: dameAppBar(titulo: "APP BOBINAS ${sVersion!}", fontSize: responsive.diagonalPorc(3)),
        drawer: SizedBox(
          width: responsive.anchoPorc(80),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      //color: miColorFondo,
                      ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Maquina por defecto',
                          style: TextStyle(
                            color: miColorBotones,
                            fontSize: responsive.altoPorc(2),
                          ),
                        ),
                      ),
                      misDatos.usuario.getMaquinas!.isNotEmpty
                          ? Container(
                              height: responsive.altoPorc(5),
                              padding: EdgeInsets.only(left: 5.0),
                              decoration: BoxDecoration(border: Border.all(color: miColorBotones, width: 0.5)), //borderRadius: BorderRadius.circular(15.0)),
                              child: DropdownButton<int>(
                                value: iMaquinaSeleccionada,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                elevation: 5,
                                isExpanded: true,
                                style: TextStyle(
                                  color: miColorBotones,
                                  fontSize: 15.0,
                                ),
                                underline: Container(),
                                dropdownColor: miColorGris,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    iMaquinaSeleccionada = newValue;
                                    int? iMaq = misDatos.usuario.getMaquinas!.where((maquina) => maquina.codigo == iMaquinaSeleccionada).toList().first.codigo;

                                    if (iMaq! > 0) {
                                      misDatos.usuario.setMaquinaSeleccionada(iMaq);
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                items: misMaquinas!.map((maq) {
                                  return DropdownMenuItem(
                                    value: maq.codigo,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.print),
                                        SizedBox(width: 5.0),
                                        Flexible(
                                          child: Container(alignment: Alignment.centerLeft, child: Text(maq.nombre.toString(), textAlign: TextAlign.left, overflow: TextOverflow.ellipsis)),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : SizedBox(
                              height: 20.0,
                              child: Text("Sin Maquinas asociadas"),
                            ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Impresora por defecto',
                          style: TextStyle(
                            color: miColorBotones,
                            fontSize: responsive.altoPorc(2),
                          ),
                        ),
                      ),
                      misDatos.usuario.getImpresoras.isNotEmpty
                          ? Container(
                              height: responsive.altoPorc(5),
                              padding: EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(border: Border.all(color: miColorBotones, width: 1.0)),
                              child: DropdownButton<String>(
                                value: sImpresoraSeleccionada,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                elevation: 5,
                                isExpanded: true,
                                style: TextStyle(
                                  color: miColorBotones,
                                  fontSize: 15.0,
                                ),
                                underline: Container(),
                                dropdownColor: miColorGris,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    sImpresoraSeleccionada = newValue;
                                    String sImp = misDatos.usuario.getImpresoras.where((imp) => imp == sImpresoraSeleccionada).toList().first;

                                    if (sImp.trim().isNotEmpty) {
                                      misDatos.usuario.setImpresoraSeleccionada(sImp);
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                items: misImpresoras!.map((imp) {
                                  return DropdownMenuItem(
                                    value: imp,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.print),
                                        SizedBox(width: 5.0),
                                        Flexible(
                                          child: Container(alignment: Alignment.centerLeft, child: Text(imp, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis)),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : SizedBox(
                              height: 20.0,
                              child: Text("Sin impresoras instaladas en Servidor"),
                            )
                    ],
                  ),
                ),
                ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.build_circle,
                          size: responsive.diagonalPorc(3),
                        ),
                        SizedBox(
                          width: responsive.anchoPorc(5),
                        ),
                        Text('Config. Conexion', style: TextStyle(fontSize: responsive.diagonalPorc(1.5))),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/Configuracion");
                    }),
                ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.book,
                          size: responsive.diagonalPorc(3),
                        ),
                        SizedBox(
                          width: responsive.anchoPorc(5),
                        ),
                        Text('Documentacion', style: TextStyle(fontSize: responsive.diagonalPorc(1.5))),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/Documentacion");
                      /* String ruta = misDatos.usuario.rutaDocumentacionAPP;
                      try {
                       Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaginaReproductor(sRutaVideo: "$ruta/CalibracionZT220.mp4",)));
                        //OpenFile.open("$ruta/CalibracionZT220.mp4");
                      } catch (e) {
                        mostrarMensaje(true, e.message);
                      }*/
                    }),
                ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app, size: responsive.diagonalPorc(3)),
                        SizedBox(
                          width: responsive.anchoPorc(5),
                        ),
                        Text('Cerrar Sesion', style: TextStyle(fontSize: responsive.diagonalPorc(1.5))),
                      ],
                    ),
                    onTap: () {
                      _cerrarSesion();
                    }),
              ],
            ),
          ),
        ),
        body: misDatos.usuario.creado
            ? dameMenuPrincipal()
            : bConectando!
                ? Center(
                    child: CircularProgressIndicator(
                    strokeWidth: 8.0,
                  ))
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Sin conexion",
                            style: TextStyle(fontSize: responsive.diagonalPorc(2)),
                          )),
                      Boton(
                        texto: "RECONECTAR",
                        ancho: responsive.anchoPorc(40),
                        alto: responsive.altoPorc(10),
                        pAccion: () => {conectar()},
                      )
                    ], //  botonWidget(context, "RECONECTAR", pAccion: () => {conectar()})],
                  )),
      ),
    );
  }

  Widget dameMenuPrincipal() {
    return Center(
        child: downloading
            ? SizedBox(
                height: 120.0,
                width: 200.0,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Downloading File: $progressString",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : ListView(children: <Widget>[
                Divider(),
                ListTile(
                  title: Text("Colocar Bobina", style: miEstiloMenuItem),
                  subtitle: Text(
                    "Coloca una bobina en el grupo para que sea consumida en maquina",
                    style: miEstiloMenuSubTitulo,
                  ),
                  leading: Image(
                    image: AssetImage('imagenes/Colocar.png'),
                    width: heigthIconoMenuItem,
                    height: heigthIconoMenuItem,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/ColocarBobina");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Retirar Bobina", style: miEstiloMenuItem),
                  subtitle: Text(
                    "Retira una bobina del grupo",
                    style: miEstiloMenuSubTitulo,
                  ),
                  leading: Image(
                    image: AssetImage('imagenes/Retirar.png'),
                    width: heigthIconoMenuItem,
                    height: heigthIconoMenuItem,
                  ),
                  onTap: () {
                    iOpcionEscogida = OpcionesInterfaz.RetirarBobina;
                    Navigator.pushNamed(context, "/RetirarBobina");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Recuperar Bobina", style: miEstiloMenuItem),
                  subtitle: Text(
                    "Recupera las ultimas bobinas que ha sido consumidas en el grupo",
                    style: miEstiloMenuSubTitulo,
                  ),
                  leading: Image(
                    image: AssetImage('imagenes/Devolver.png'),
                    width: heigthIconoMenuItem,
                    height: heigthIconoMenuItem,
                  ),
                  onTap: () {
                    iOpcionEscogida = OpcionesInterfaz.RecuperarUltimaBobina;
                    Navigator.pushNamed(context, '/RecuperarBobina');
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Consultar Bobina", style: miEstiloMenuItem),
                  subtitle: Text(
                    "Consulta los datos de una bobina dada de alta en el sistema",
                    style: miEstiloMenuSubTitulo,
                  ),
                  leading: Image(
                    image: AssetImage('imagenes/Buscar24.png'),
                    width: heigthIconoMenuItem,
                    height: heigthIconoMenuItem,
                  ),
                  onTap: () {
                    iOpcionEscogida = OpcionesInterfaz.ConsultarBobina;
                    Navigator.pushNamed(context, "/ConsultarBobina");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Retirar Bobina Radio", style: miEstiloMenuItem),
                  subtitle: Text(
                    "Retira una bobina que se recupera sin peso",
                    style: miEstiloMenuSubTitulo,
                  ),
                  leading: Image(
                    image: AssetImage('imagenes/Radio64.png'),
                    width: heigthIconoMenuItem,
                    height: heigthIconoMenuItem,
                  ),
                  onTap: () {
                    iOpcionEscogida = OpcionesInterfaz.RetirarBobinaRadio;
                    Navigator.pushNamed(context, "/RetirarBobinaRadio");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Re-imprimir Etiqueta", style: miEstiloMenuItem),
                  subtitle: Text(
                    "Reimprime una etiqueta de una bobina",
                    style: miEstiloMenuSubTitulo,
                  ),
                  leading: Image(
                    image: AssetImage('imagenes/impresora.png'),
                    width: heigthIconoMenuItem,
                    height: heigthIconoMenuItem,
                  ),
                  onTap: () {
                    iOpcionEscogida = OpcionesInterfaz.ReimprimirEtiqueta;
                    Navigator.pushNamed(context, "/ReimprimirEtiqueta");
                  },
                ),
                Divider()
              ]));
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  Future<void> descargarFicheroActualizacion() async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();

    try {
      await dio.download(misDatos.usuario.rutaActualizacionAPP, "${dir.path}/$sNombreAPP.apk", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completado";
      OpenFile.open("${dir.path}/$sNombreAPP.apk");
    });
    print("Descarga completada");
  }

  void actualizar() {
    showDialog(
      context: context,
      barrierDismissible: false, //Evita que se salga al tocar fuera del alertDialog
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          actionsPadding: EdgeInsets.all(0.0),
          backgroundColor: Colors.white,
          title: Text(
            "ATENCION",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ),
          contentPadding: EdgeInsets.all(5.0),
          content: SizedBox(
            height: (MediaQuery.of(context).size.height * 0.30),
            width: (MediaQuery.of(context).size.width * 0.30),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "ACTUALIZACION DISPONIBLE APP",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                color: miColorBotones,
                height: 80.0,
                width: (MediaQuery.of(context).size.width) * 0.30,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "ACTUALIZAR",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    )),
              ),
              onPressed: () {
                setState(() {
                  bDescargaFichero = true;
                });

                if (misDatos.usuario.rutaActualizacionAPP.trim().isNotEmpty) {
                  descargarFicheroActualizacion();
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                color: miColorBotones,
                height: 80.0,
                width: (MediaQuery.of(context).size.width) * 0.30,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "NO",
                      style: TextStyle(fontSize: 15.0),
                    )),
              ),
              onPressed: () {
                setState(() {
                  downloading = false;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _cerrarSesion() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Atencion"),
          content: Text("¿Esta seguro de cerrar la aplicacion?"),
          actions: <Widget>[
            TextButton(
              child: Text("SI"),
              onPressed: () {
                exit(0);
              },
            ),
            TextButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
