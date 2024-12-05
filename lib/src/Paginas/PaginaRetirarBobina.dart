import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PedirCodigoBarrasManual.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Dialogos.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/Label.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/boton.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

class PaginaRetirarBobina extends StatefulWidget {
  const PaginaRetirarBobina({super.key});

  @override
  _PaginaRetirarBobinaState createState() => _PaginaRetirarBobinaState();
}

class _PaginaRetirarBobinaState extends State<PaginaRetirarBobina> {
  String sCodigoBarrasBobina = "";
  String sGrupo = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Datos misDatos = Datos();
  final formKey = GlobalKey<FormState>();

  bool bOcultarDatosBobina = true;
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusGrupo = FocusNode();
  bool bOcultarGrupo = false;
  bool bOcultarCodigoBarras = true;
  bool bOcultarBotonOB = true;
  bool _bEstaCargando = false;
  BBDD? _miBBDD;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    void imprimirOB() {
      if (misDatos.usuario.impresoraSeleccionada!.trim().isEmpty) {
        mostrarMensaje(true, "Debe de seleccionar una impresora");
      } else {
        sCodigoBarrasBobina = misDatos.bobina.codigoInternoBobina!;

        if (sGrupo.isNotEmpty) {
          if (sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras) {
            mostrarMensaje(true, 'Minimo $maximoCaracteresCodigoBarras caracteres');
          } else {
            validarCodigoBarras();
          }
        }
      }
    }

    void pedirOCManual() async {
      sCodigoBarrasBobina = await Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaCodigoBarrasManual()));
      setState(() {});
      if (sCodigoBarrasBobina.isNotEmpty) {
        ejecutarProceso();
      }
    }

    Boton cmdImprimirOB = Boton(
      texto: "IMP. OB BOBINA",
      pAccion: () => {imprimirOB()},
      ancho: responsive.anchoPorc(30),
      alto: responsive.altoPorc(8),
    );
    Boton cmdPedirOCManual = Boton(
      texto: "ETIQ. MANUAL",
      pAccion: () => {pedirOCManual()},
      ancho: responsive.anchoPorc(30),
      alto: responsive.altoPorc(8),
    );

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("RETIRAR BOBINA", style: miEstiloCabeceraPagina),
          backgroundColor: miColorFondo,
          iconTheme: IconThemeData(color: miColorBotones),
        ),
        body: SingleChildScrollView(
          //hace scroll si el teclado tapa pantalla
          child: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width * 0.80),
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onFieldSubmitted: (String key) {
                          if (sGrupo != "") {
                            validarGrupo();
                          } else {
                            enviarFoco(true);
                          }
                        },
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        focusNode: myFocusGrupo,
                        controller: TextEditingController(text: sGrupo),
                        onChanged: (value) => sGrupo = value,
                        //    onSaved: (value) => sCodigoBarrasBobina = value,
                        validator: (value) {
                          return sGrupo.length > maximoCaracteresGRUPO ? "maximo $maximoCaracteresGRUPO caracteres" : null;
                        },
                        maxLength: maximoCaracteresGRUPO,
                        decoration: InputDecoration(
                          labelStyle: miEstiloTextFormField,
                          labelText: "GRUPO",
                        ),
                      ),
                    ),
                    bOcultarDatosBobina
                        ? SizedBox()
                        : ClipRRect(
                            // borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(15),
                                //   color: miColorGris,
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.white],
                                  begin: Alignment.center,
                                  end: Alignment.topCenter,
                                ),
                                /* boxShadow: [
                                BoxShadow(
                                  color: miColorBotones,
                                  offset: Offset(0.0, 2.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],*/
                              ),
                              margin: EdgeInsets.only(bottom: 2, right: 0),
                              padding: EdgeInsets.all(5),
                              width: responsive.anchoPorc(99),
                              height: responsive.altoPorc(50),
                              child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
                                Label(
                                  label: 'Bobina',
                                  valor: '${misDatos.bobina.codigoProveedor} - ${misDatos.bobina.codigoBobina!}',
                                  fontSize: responsive.diagonalPorc(2),
                                  colorLabel: miColorBotones,
                                  ancho: responsive.anchoPorc(30),
                                ),
                                Divider(),
                                Label(
                                  label: 'Tipo Pap.',
                                  valor: '${misDatos.bobina.grupo!} (${misDatos.bobina.articulo})',
                                  fontSize: responsive.diagonalPorc(2),
                                  colorLabel: miColorBotones,
                                  ancho: responsive.anchoPorc(30),
                                ),
                                Divider(),
                                Label(
                                  label: 'OB / OC',
                                  valor: misDatos.bobina.codigoInternoBobina.toString(),
                                  fontSize: responsive.diagonalPorc(2),
                                  colorLabel: miColorBotones,
                                  ancho: responsive.anchoPorc(30),
                                ),
                                Divider(),
                                Label(
                                  label: 'Peso',
                                  valor: '${formatearEntero(misDatos.bobina.cantidad!)} ${misDatos.bobina.unidad!}',
                                  fontSize: responsive.diagonalPorc(2),
                                  colorLabel: miColorBotones,
                                  ancho: responsive.anchoPorc(30),
                                ),
                                Divider(),
                                Label(
                                  label: 'Longitud',
                                  valor: formatearEntero(misDatos.bobina.longitud!),
                                  fontSize: responsive.diagonalPorc(2),
                                  colorLabel: miColorBotones,
                                  ancho: responsive.anchoPorc(30),
                                ),
                                Divider(),
                              ]),
                            ),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    _bEstaCargando
                        ? SizedBox()
                        : bOcultarCodigoBarras
                            ? SizedBox()
                            : Container(
                                width: (MediaQuery.of(context).size.width * 0.80),
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.none,
                                  autofocus: true,
                                  onFieldSubmitted: (String key) {
                                    validarCodigoBarras();
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
                                    labelText: "Codigo de barras OC",
                                  ),
                                ),
                              ),
                  ],
                ),
              )),
        ),
        persistentFooterButtons: [
          bOcultarDatosBobina
              ? SizedBox()
              : _bEstaCargando
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        bOcultarBotonOB ? SizedBox() : cmdImprimirOB,
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.10),
                        ),
                        cmdPedirOCManual
                      ],
                    ),
        ]);
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusGrupo = FocusNode();
    _bEstaCargando = false;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    myFocusGrupo.dispose();
  }

  void grupoActivo() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false, //evita que se salga al tocar fuera del mensaje
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          actionsPadding: EdgeInsets.all(0.0),
          backgroundColor: miColorFondo,
          title: Text(
            "Atencion",
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
                "Grupo Activo. ¿Retirar Bobina?",
                textAlign: TextAlign.center,
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
                setState(() {});
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

  void inicializarVariables() {
    setState(() {
      sGrupo = "";
      sCodigoBarrasBobina = "";
      bOcultarBotonOB = true;
      bOcultarCodigoBarras = true;
      bOcultarDatosBobina = true;
      _bEstaCargando = false;
    });
  }

  void enviarFoco(bool grupo) {
    FocusScope.of(context).unfocus();

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
    if (sGrupo.length > maximoCaracteresGRUPO) {
      mostrarMensaje(true, 'El grupo no puede tener mas de $maximoCaracteresGRUPO caracteres');
      enviarFoco(true);
    } else {
      setState(() {});
      ProgressDialog.show(context);
      _miBBDD = GetIt.instance<BBDD>();
      final RespuestaHTTP<Bobina> miRespuesta = await _miBBDD!.retirarBobina(grupo: sGrupo, codigoBarras: "0", impresora: "0");

      ProgressDialog.dissmiss(context);
      misDatos.setBobina(miRespuesta.data!);
      setState(() {
        bOcultarDatosBobina = false;
      });
      if (misDatos.bobina.mensaje.toString().trim().length >= 0) {
        grupoActivo();
        setState(() {
          if (misDatos.bobina.codigoInternoBobina!.trim().isEmpty) {
            bOcultarBotonOB = true;
          } else {
            bOcultarBotonOB = false;
          }
        });
      } else {
        // enviarFoco(false);
      }

      _bEstaCargando = false;
      setState(() {});
      ProgressDialog.dissmiss(context);
    }
  }

  void validarCodigoBarras() {
    if (sGrupo.isNotEmpty) {
      if (sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras) {
        mostrarMensaje(true, 'Minimo $maximoCaracteresCodigoBarras caracteres');
        enviarFoco(false);
      } else {
        ejecutarProceso();
      }
    } else {
      mostrarMensaje(true, 'Debe rellenar el GRUPO');
    }
  }

  void ejecutarProceso() async {
    ProgressDialog.show(context);

    _bEstaCargando = true;
    setState(() {});

    final RespuestaHTTP<Bobina> miRespuesta = await _miBBDD!.retirarBobina(grupo: sGrupo, codigoBarras: sCodigoBarrasBobina, impresora: misDatos.usuario.impresoraSeleccionada!);

    ProgressDialog.dissmiss(context);

    misDatos.setBobina(miRespuesta.data!);
    mostrarMensaje(false, misDatos.bobina.mensaje.toString().trim());
    inicializarVariables();
    enviarFoco(true);
    _bEstaCargando = false;
    setState(() {});
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
