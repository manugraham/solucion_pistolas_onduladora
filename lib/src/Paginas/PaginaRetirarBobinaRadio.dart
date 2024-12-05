import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Dialogos.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/Label.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/boton.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

import 'PedirCodigoBarrasManual.dart';

class PaginaRetirarBobinaRadio extends StatefulWidget {
  const PaginaRetirarBobinaRadio({super.key});

  @override
  _PaginaRetirarBobinaRadioState createState() => _PaginaRetirarBobinaRadioState();
}

class _PaginaRetirarBobinaRadioState extends State<PaginaRetirarBobinaRadio> {
  int iOpcionesRespuesta = 1;
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusGrupo = FocusNode();
  FocusNode myFocusRadio = FocusNode();
  bool bOcultarBotonOB = true;
  bool bOcultarDatos = true;
  String sRadio = "";
  String sGrupo = "";
  String sCodigoBarrasBobina = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Datos misDatos = Datos();
  final formKey = GlobalKey<FormState>();
  BBDD? _miBBDD;

  bool _bEstaCargando = false;

  _PaginaRetirarBobinaRadioState() {
    myFocusNode = FocusNode();
    myFocusGrupo = FocusNode();
    myFocusRadio = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    myFocusGrupo.dispose();
    myFocusRadio.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bEstaCargando = false;
    setState(() {});
  }

  void inicializarVariables() {
    setState(() {
      sGrupo = "";
      sCodigoBarrasBobina = "";
      sRadio = "";
      bOcultarBotonOB = true;

      bOcultarDatos = true;
      _bEstaCargando = false;
    });
  }

  void enviarFoco(OpcionesFocus opcion) {
    switch (opcion) {
      case OpcionesFocus.Grupo:
        {
          FocusScope.of(context).requestFocus(myFocusGrupo);
        }
        break;
      case OpcionesFocus.CodigoBarras:
        {
          FocusScope.of(context).requestFocus(myFocusNode);
        }
        break;
      case OpcionesFocus.Radio:
        {
          FocusScope.of(context).requestFocus(myFocusRadio);
        }
        break;
      default:
        {}
        break;
    }
  }

  void validarDatos() async {
    setState(() {});

    if (sGrupo.length > maximoCaracteresGRUPO) {
      mostrarMensaje(true, 'El grupo no puede tener mas de $maximoCaracteresGRUPO caracteres');
      enviarFoco(OpcionesFocus.Grupo);
    } else {
      if (sGrupo.isEmpty) {
        mostrarMensaje(true, 'Debe de introducir un GRUPO');
        enviarFoco(OpcionesFocus.Grupo);
      } else {
        if (sRadio.isEmpty) {
          mostrarMensaje(true, 'Debe de introducir un RADIO');
          enviarFoco(OpcionesFocus.Radio);
        } else {
          ProgressDialog.show(context);

          _miBBDD = GetIt.instance<BBDD>();

          final RespuestaHTTP<Bobina> miRespuesta = await _miBBDD!.retirarBobinaRadio(grupo: sGrupo, radio: sRadio, codigoBarras: "0", impresora: "0");

          ProgressDialog.dissmiss(context);
          misDatos.setBobina(miRespuesta.data!);
          setState(() {
            bOcultarDatos = false;
            _bEstaCargando = false;

            if (misDatos.bobina.codigoInternoBobina!.trim().isEmpty) {
              bOcultarBotonOB = true;
            } else {
              bOcultarBotonOB = false;
            }

            enviarFoco(OpcionesFocus.CodigoBarras);
          });
        }
      }
    }
  }

  void validarCodigoBarras() {
    if (sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras) {
      mostrarMensaje(true, 'Minimo $maximoCaracteresCodigoBarras caracteres');
    } else {
      ejecutarProceso();
    }
  }

  void ejecutarProceso() async {
    ProgressDialog.show(context);
    iOpcionesRespuesta = 2;
    _bEstaCargando = true;
    setState(() {});

    final RespuestaHTTP<Bobina> miRespuesta = await _miBBDD!.retirarBobinaRadio(grupo: sGrupo, radio: sRadio, codigoBarras: sCodigoBarrasBobina, impresora: misDatos.usuario.impresoraSeleccionada!);

    ProgressDialog.dissmiss(context);
    misDatos.setBobina(miRespuesta.data!);
    mostrarMensaje(false, misDatos.bobina.mensaje.toString().trim());
    inicializarVariables();
    enviarFoco(OpcionesFocus.Grupo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    void imprimirOBBobina() {
      if (misDatos.usuario.impresoraSeleccionada!.trim().isEmpty) {
        mostrarMensaje(true, "Debe de seleccionar una impresora");
      } else {
        sCodigoBarrasBobina = misDatos.bobina.codigoInternoBobina!;
        validarCodigoBarras();
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
      pAccion: () => {imprimirOBBobina()},
      ancho: responsive.anchoPorc(30),
      alto: responsive.altoPorc(8),
    );
    Boton cmdPedirOCManual = Boton(
      texto: "OC MANUAL",
      pAccion: () => {pedirOCManual()},
      ancho: responsive.anchoPorc(30),
      alto: responsive.altoPorc(8),
    );

    var loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width * 0.80),
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  onFieldSubmitted: (String key) {
                    enviarFoco(OpcionesFocus.Radio);
                  },
                  focusNode: myFocusGrupo,
                  controller: TextEditingController(text: sGrupo),
                  onChanged: (value) => sGrupo = value,
                  validator: (value) {
                    return sGrupo.length > maximoCaracteresGRUPO ? "maximo $maximoCaracteresGRUPO caracteres" : null;
                  },
                  maxLength: maximoCaracteresGRUPO,
                  decoration: InputDecoration(
                    labelStyle: miEstiloTextFormField,
                    labelText: "GRUPO",
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                    ),
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width * 0.80),
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (String key) {
                    validarDatos();
                  },
                  focusNode: myFocusRadio,
                  controller: TextEditingController(text: sRadio),
                  onChanged: (value) => sRadio = value,
                  validator: (value) {
                    return sRadio.length < minimoCaracteresRadio ? "Minimo $minimoCaracteresRadio caracteres" : null;
                  },
                  maxLength: maximoCaracteresGRUPO,
                  decoration: InputDecoration(
                    labelStyle: miEstiloTextFormField,
                    labelText: "Indique Radio (cm)",
                  ),
                ),
              ),
              bOcultarDatos
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
              /* new Container(
                      width: (MediaQuery.of(context).size.width * 0.80),
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        onFieldSubmitted: (String key) {
                          validarCodigoBarras();
                        },
                        autofocus: true,
                        focusNode: myFocusNode,
                        style: miEstiloTextFormField,
                        controller: new TextEditingController(text: '$sCodigoBarrasBobina'),
                        onChanged: (value) => sCodigoBarrasBobina = value,
                        validator: (value) {
                          return sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras ? "Minimo " + maximoCaracteresCodigoBarras.toString() + " caracteres" : null;
                        },
                        maxLength: maximoCaracteresCodigoBarras,
                        decoration: new InputDecoration(
                          labelText: "CODIGO BARRAS OC",
                        ),
                      ),
                    ),*/
            ],
          ),
        ),

        // _bEstaCargado ? SizedBox() : cmdAbrirCamara,
      ],
    );

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("RETIRAR BOBINA RADIO", style: miEstiloCabeceraPagina),
          backgroundColor: miColorFondo,
          iconTheme: IconThemeData(color: miColorBotones),
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: SingleChildScrollView(child: loginForm),
            )),
        persistentFooterButtons: [
          bOcultarDatos
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

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
