import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaElegirBobinas.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Dialogos.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/boton.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

class PaginaColocarBobina extends StatefulWidget {
  const PaginaColocarBobina({super.key});

  @override
  _PaginaColocarBobinaState createState() => _PaginaColocarBobinaState();
}

class _PaginaColocarBobinaState extends State<PaginaColocarBobina> {
  FocusNode? myFocusNode;
  FocusNode? myFocusGrupo;
  bool _bEstaCargando = false;
  String sCodigoBarrasBobina = "";
  String sGrupo = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Datos misDatos = Datos();
  final formKey = GlobalKey<FormState>();
  bool bOcultarDatos = true;
  BBDD? _miBBDD;

  @override
  void dispose() {
    super.dispose();
    myFocusNode!.dispose();
    myFocusGrupo!.dispose();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusGrupo = FocusNode();
    setState(() {});
  }

  void hayBobinaActiva() {
    showDialog(
      context: context,
      barrierDismissible: false, //Evita que se salga al tocar fuera del alertDialog
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          actionsPadding: EdgeInsets.all(0.0),
          backgroundColor: miColorFondo,
          title: Text(
            "ATENCION",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35.0),
          ),
          contentPadding: EdgeInsets.all(5.0),
          content: SizedBox(
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Hay Bobina activa en el grupo. ¿Activar la nueva bobina?",
                style: TextStyle(fontSize: 25.0),
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
                      "SI",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25.0),
                    )),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                enviarFoco(false);
                //hay que llevar el foco al segundo textboxfield
                //  scanBarcodeNormal(false);
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
                      style: TextStyle(fontSize: 25.0),
                    )),
              ),
              onPressed: () {
                inicializarVariables();
                Navigator.of(context).pop();
                enviarFoco(true);
              },
            )
          ],
        );
      },
    );
  }

  void enviarFoco(bool grupo) {
    if (grupo) {
      FocusScope.of(context).requestFocus(myFocusGrupo);
    } else {
      FocusScope.of(context).requestFocus(myFocusNode);
    }
  }

  Future scanBarcodeNormal(bool grupo) async {
    try {
      if (grupo) {
        sGrupo = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.BARCODE);

        if (sGrupo == "-1") {
          sGrupo = "";
        }
        setState(() {});

        if (sGrupo != "") {
          validarGrupo();
        }
      } else {
        sCodigoBarrasBobina = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.BARCODE);
        if (sCodigoBarrasBobina == "-1") {
          sCodigoBarrasBobina = "";
        }
        setState(() {});

        if (sCodigoBarrasBobina != "") {
          validarCodigoBarras();
        }
      }
    } catch (err) {}
  }

  void validarGrupo() async {
    try {
      if (sGrupo.length > 3) {
        mostrarMensaje(true, 'El grupo no puede tener mas de 3 caracteres');
        enviarFoco(true);
      } else {
        if (sGrupo.isEmpty) {
          mostrarMensaje(true, 'Debe introducir un Grupo');
          enviarFoco(true);
        } else {
          ProgressDialog.show(context);

          _miBBDD = GetIt.instance<BBDD>();
          final RespuestaHTTP<String> miRespuesta = await _miBBDD!.comprobarGrupo(grupo: sGrupo);

          ProgressDialog.dissmiss(context);
          setState(() {
            sCodigoBarrasBobina = "";
            oCultarBoton(false);
            //bOcultarDatos = false;
            _bEstaCargando = false;
          });

          if (miRespuesta.data!.isNotEmpty) {
            hayBobinaActiva();
          } else {
            enviarFoco(false);
          }
        }
      }
    } catch (err) {
      mostrarMensaje(true, err.toString());
    } finally {}
  }

  void validarCodigoBarras() async {
    if (sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras) {
      mostrarMensaje(true, 'Minimo $maximoCaracteresCodigoBarras caracteres');
      enviarFoco(false);
    } else {
      ProgressDialog.show(context);

      final RespuestaHTTP<String> miRespuesta = await _miBBDD!.colocarBobina(grupo: sGrupo, codigoBobina: sCodigoBarrasBobina);

      ProgressDialog.dissmiss(context);
      mostrarMensaje(false, "${miRespuesta.data!} COLOCADA CORRECTAMENTE");
      inicializarVariables();
      enviarFoco(true);
    }
  }

  void bobinasEnPulmon() {
    if (sGrupo.isEmpty) {
      mostrarMensaje(true, "Debe de escoger un grupo");
    } else {
      misDatos.setGrupo(sGrupo);

      _elegirBobinaPulmon(context);
    }
  }

  _elegirBobinaPulmon(BuildContext context) async {
    sCodigoBarrasBobina = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaElegirBobinas(
                  miOpcion: OpcionesElegirBobinas.BobinasEnPulmon,
                )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    var loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Form(
          key: formKey,
          child: GestureDetector(
            onTap: () {
              ocultarTeclado(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width * 0.80),
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onFieldSubmitted: (String key) {
                      if (key.trim().isNotEmpty) {
                        validarGrupo();
                      } else {
                        enviarFoco(true);
                      }
                    },
                    style: miEstiloTextFormField,
                    autofocus: true,
                    focusNode: myFocusGrupo,
                    controller: TextEditingController(text: sGrupo),
                    onChanged: (value) => sGrupo = value,
                    validator: (value) {
                      return sGrupo.length > maximoCaracteresGRUPO ? "maximo $maximoCaracteresGRUPO caracteres" : null;
                    },
                    maxLength: maximoCaracteresGRUPO,
                    decoration: InputDecoration(labelText: "GRUPO"),
                  ),
                ),
                _bEstaCargando
                    ? Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 8.0,
                      ))
                    : Container(
                        width: (MediaQuery.of(context).size.width * 0.80),
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onFieldSubmitted: (String key) {
                            if (key.trim().isNotEmpty) {
                              validarCodigoBarras();
                            } else {
                              enviarFoco(false);
                            }
                          },
                          focusNode: myFocusNode,
                          controller: TextEditingController(text: sCodigoBarrasBobina),
                          onChanged: (value) => sCodigoBarrasBobina = value,
                          validator: (value) {
                            return sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras ? "Minimo $maximoCaracteresCodigoBarras caracteres" : null;
                          },
                          maxLength: maximoCaracteresCodigoBarras,
                          decoration: InputDecoration(
                            labelStyle: miEstiloTextFormField,
                            labelText: "Codigo Barras",
                          ),
                        ),
                      ),
                bOcultarDatos ? SizedBox() : Boton(texto: "BOB. PULMON", pAccion: () => {bobinasEnPulmon()}, ancho: responsive.anchoPorc(40.0), alto: responsive.altoPorc(10))
              ],
            ),
          ),
        ),
        // cmdConsultar,
        // _bEstaCargado ? SizedBox() : cmdAbrirCamara,
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("COLOCAR BOBINA EN GRUPO", style: miEstiloCabeceraPagina),
        backgroundColor: miColorFondo,
        iconTheme: IconThemeData(color: miColorBotones),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: loginForm,
          )),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  void inicializarVariables() {
    setState(() {
      sGrupo = "";
      sCodigoBarrasBobina = "";
      oCultarBoton(true);
      //bOcultarDatos = true;
    });
  }

  void oCultarBoton(bool ocultarBoton) {
    var now = DateTime.now();
    print(now);
    //Si la hora actual es horario oficina y queremos mostrar el boton se hace, sino no mostramos el boton
    if ((now.hour >= 17 && now.minute >= 30) && (now.hour <= 9) && !ocultarBoton) {
      bOcultarDatos = false;
    } else {
      bOcultarDatos = true;
    }
    setState(() {});
  }
}
