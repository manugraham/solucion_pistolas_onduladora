import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Dialogos.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/boton.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

import 'PaginaElegirBobinas.dart';

class PaginaReimprimirEtiqutas extends StatefulWidget {
  const PaginaReimprimirEtiqutas({super.key});

  @override
  _PaginaReimprimirEtiqutasState createState() => _PaginaReimprimirEtiqutasState();
}

class _PaginaReimprimirEtiqutasState extends State<PaginaReimprimirEtiqutas> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode miFocusNode = FocusNode(canRequestFocus: false);
  List<String>? misImpresoras;
  Datos misDatos = Datos();
  bool bImprimiendo = false;
  final formKey = GlobalKey<FormState>();
  String _sCodigo = "";
  bool _bPorGrupos = false;
  String _sTextoBobon = "ETIQUETA";
  BBDD? _miBBDD;

  @override
  void initState() {
    miFocusNode = FocusNode();

    super.initState();
  }

  void enviarFoco() {
    FocusScope.of(context).requestFocus(miFocusNode);
  }

  void _elegirBobinaRecuperadasGrupo(BuildContext context) async {
    _sCodigo = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaElegirBobinas(
                  miOpcion: OpcionesElegirBobinas.BobinasRecuperadasGrupo,
                )));

    validarCodigoBarras();
    setState(() {});
  }

  void validarGrupo() async {
    if (_sCodigo.isEmpty) {
      mostrarMensaje(true, 'Debe de introducir el grupo');
    } else {
      if (misDatos.usuario.impresoraSeleccionada!.trim().isEmpty) {
        mostrarMensaje(true, 'Debe de seleccionar una impresora');
      } else {
        misDatos.setGrupo(_sCodigo);

        _elegirBobinaRecuperadasGrupo(context);

/*

          ProgressDialog.show(context);
          _miBBDD = GetIt.instance<BBDD>();

          final RespuestaHTTP<String> miRespuesta = await _miBBDD.imprimirUltimaBobinaGrupo(grupo: _sCodigo, impresora: misDatos.usuario.impresoraSeleccionada);

          if (miRespuesta.data != null) {
            setState(() {
              bImprimiendo = false;
              _sCodigo = "";
            });
            enviarFoco();
            mostrarMensaje(false, miRespuesta.data);
          } else {
            mostrarMensaje(true, miRespuesta.error.mensaje);
            comprobarTipoError(context, miRespuesta.error);
          }

          ProgressDialog.dissmiss(context);*/
      }
    }
  }

  void validarCodigoBarras() async {
    if (_sCodigo.isEmpty) {
      mostrarMensaje(true, 'Debe de introducir el codigo de una etiqueta');
    } else {
      if (misDatos.usuario.impresoraSeleccionada!.trim().isEmpty) {
        mostrarMensaje(true, 'Debe de seleccionar una impresora');
      } else {
        ProgressDialog.show(context);
        _miBBDD = GetIt.instance<BBDD>();

        final RespuestaHTTP<String> misDatosBobina = await _miBBDD!.imprimirBobina(codigoBobina: _sCodigo, impresora: misDatos.usuario.impresoraSeleccionada!);

        setState(() {
          bImprimiendo = false;
          _sCodigo = "";
        });
        enviarFoco();
        mostrarMensaje(false, misDatosBobina.data!);

        ProgressDialog.dissmiss(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    var miformulario = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  controller: TextEditingController(text: _sCodigo),
                  onFieldSubmitted: (String key) {
                    _bPorGrupos ? validarGrupo() : validarCodigoBarras();
                  },
                  autofocus: true,
                  onChanged: (value) => _sCodigo = value,
                  validator: (value) {
                    if (_bPorGrupos) {
                      return _sCodigo.length > maximoCaracteresGRUPO ? "maximo $maximoCaracteresGRUPO caracteres" : '';
                    } else {
                      return _sCodigo.length > maximoCaracteresCodigoBarras ? "maximo $maximoCaracteresCodigoBarras caracteres" : '';
                    }
                  },
                  maxLength: _bPorGrupos ? maximoCaracteresGRUPO : maximoCaracteresCodigoBarras,
                  decoration: InputDecoration(labelStyle: miEstiloTextFormField, labelText: _sTextoBobon),
                ),
              ),
              bImprimiendo
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 8.0,
                    ))
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bPorGrupos
                      ? SizedBox()
                      : Boton(
                          texto: "GRUPO",
                          pAccion: () {
                            setState(() {
                              _bPorGrupos = true;
                              _sTextoBobon = "GRUPO";
                              _sCodigo = "";
                            });
                          },
                          ancho: responsive.anchoPorc(35),
                          alto: responsive.altoPorc(8)),
                  !_bPorGrupos
                      ? SizedBox()
                      : Boton(
                          texto: "COD. BARRAS",
                          pAccion: () {
                            setState(() {
                              _bPorGrupos = false;
                              _sTextoBobon = "ETIQUETA";
                              _sCodigo = "";
                            });
                          },
                          ancho: responsive.anchoPorc(35),
                          alto: responsive.altoPorc(8)),
                ],
              ),
            ],
          ),
        ),
        // cmdConsultar,
        // _bEstaCargado ? SizedBox() : cmdAbrirCamara,
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("REIMPRIMIR", style: miEstiloCabeceraPagina),
        backgroundColor: miColorFondo,
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: SingleChildScrollView(child: miformulario),
          )),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
