import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Paginas/PaginaElegirBobinas.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Dialogos.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

class PaginaReucperarBobinasGrupo extends StatefulWidget {
  const PaginaReucperarBobinasGrupo({super.key});

  @override
  _PaginaReucperarBobinasGrupoState createState() => _PaginaReucperarBobinasGrupoState();
}

class _PaginaReucperarBobinasGrupoState extends State<PaginaReucperarBobinasGrupo> {
  String sGrupo = "";
  String sCodigoBarras = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Datos misDatos = Datos();
  final formKey = GlobalKey<FormState>();
  FocusNode myFocusGrupo = FocusNode();
  FocusNode myFocusCodigoBarras = FocusNode();
  bool _bBobinaEscogida = false;
  BBDD? _miBBDD;

  _PaginaReucperarBobinasGrupoState() {
    myFocusGrupo = FocusNode();
    myFocusCodigoBarras = FocusNode();
  }

  void validarGrupo() {
    if (sGrupo.length > maximoCaracteresGRUPO) {
      mostrarMensaje(true, 'El grupo no puede tener mas de $maximoCaracteresGRUPO caracteres');
      enviarFoco(OpcionesFocus.Grupo);
    } else {
      if (sGrupo.isEmpty) {
        enviarFoco(OpcionesFocus.Grupo);
      } else {
        misDatos.setGrupo(sGrupo);

        _bBobinaEscogida = true;
        setState(() {});

        _elegirBobinaPulmon(context);
      }
    }
  }

  void validarCodigoBarras() async {
    ProgressDialog.show(context);
    try {
      if (sCodigoBarras.trim().isNotEmpty) {
        _miBBDD = GetIt.instance<BBDD>();

        final RespuestaHTTP<String> miRespuesta = await _miBBDD!.recuperarBobina(codigoMaquina: misDatos.usuario.miMaquinaSeleccionada!.codigo.toString(), grupo: sGrupo, codigoBarras: sCodigoBarras);

        inicializarVariables();
        enviarFoco(OpcionesFocus.Grupo);
        mostrarMensaje(false, miRespuesta.data.toString());
      }

      sGrupo = "";
      _bBobinaEscogida = false;
      sCodigoBarras = "";
      setState(() {});
      enviarFoco(OpcionesFocus.Grupo);

      ProgressDialog.dissmiss(context);
    } catch (error) {
      mostrarMensaje(true, error.toString());
      ProgressDialog.dissmiss(context);
    }
  }

  _elegirBobinaPulmon(BuildContext context) async {
    sCodigoBarras = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaElegirBobinas(
                  miOpcion: OpcionesElegirBobinas.BobinasConsumidasGrupo,
                )));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myFocusGrupo.dispose();
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  void inicializarVariables() {
    sGrupo = "";
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
          FocusScope.of(context).requestFocus(myFocusCodigoBarras);
        }
        break;
      case OpcionesFocus.Radio:
        {
          // FocusScope.of(context).requestFocus(myFocusRadio);
        }
        break;
      default:
        {}
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginForm = Column(
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
                  onFieldSubmitted: (String key) {
                    validarGrupo();
                  },
                  autofocus: true,
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
                  ),
                ),
              ),
              !_bBobinaEscogida
                  ? SizedBox()
                  : Container(
                      width: (MediaQuery.of(context).size.width * 0.80),
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onFieldSubmitted: (String key) {
                          validarCodigoBarras();
                        },
                        autofocus: true,
                        focusNode: myFocusCodigoBarras,
                        controller: TextEditingController(text: sCodigoBarras),
                        onChanged: (value) => sCodigoBarras = value,
                        validator: (value) {
                          return sCodigoBarras.length > maximoCaracteresCodigoBarras ? "maximo $maximoCaracteresCodigoBarras caracteres" : null;
                        },
                        maxLength: maximoCaracteresCodigoBarras,
                        decoration: InputDecoration(
                          labelStyle: miEstiloTextFormField,
                          labelText: "CODIGO BARRAS",
                        ),
                      ),
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
        title: Text("RECUPERAR BOBINA", style: miEstiloCabeceraPagina),
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
}
