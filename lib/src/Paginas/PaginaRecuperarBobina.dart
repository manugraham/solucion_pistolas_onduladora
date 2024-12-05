import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Dialogos.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';

class PaginaRecuperarBobina extends StatefulWidget {
  const PaginaRecuperarBobina({super.key});

  @override
  _PaginaRecuperarBobinaState createState() => _PaginaRecuperarBobinaState();
}

class _PaginaRecuperarBobinaState extends State<PaginaRecuperarBobina> {
  String sGrupo = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Datos misDatos = Datos();
  final formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = FocusNode();
  BBDD? _miBBDD;

  _PaginaRecuperarBobinaState() {
    myFocusNode = FocusNode();
  }

  void validarGrupo() async {
    if (sGrupo.length > maximoCaracteresGRUPO) {
      mostrarMensaje(true, 'El grupo no puede tener mas de $maximoCaracteresGRUPO caracteres');
      enviarFoco();
    } else {
      if (sGrupo.isEmpty) {
        enviarFoco();
      } else {
        ProgressDialog.show(context);
        _miBBDD = GetIt.instance<BBDD>();
        final RespuestaHTTP<String> miRespuesta = await _miBBDD!.recuperarBobina(codigoMaquina: misDatos.usuario.miMaquinaSeleccionada!.codigo.toString(), grupo: sGrupo, codigoBarras: "0");

        ProgressDialog.dissmiss(context);
        inicializarVariables();
        enviarFoco();
        mostrarMensaje(false, miRespuesta.data.toString());
      }
    }
  }

  Future scanBarcodeNormal() async {
    try {
      sGrupo = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.BARCODE);

      if (sGrupo == "-1") {
        sGrupo = "";
      }
      setState(() {});

      if (sGrupo != "") {
        validarGrupo();
      }
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }

  void inicializarVariables() {
    sGrupo = "";
  }

  void enviarFoco() {
    FocusScope.of(context).requestFocus(myFocusNode);
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
                  focusNode: myFocusNode,
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
