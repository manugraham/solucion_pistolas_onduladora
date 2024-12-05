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

class PaginaConsultarBobina extends StatefulWidget {
  const PaginaConsultarBobina({super.key});

  @override
  _PaginaConsultarBobinaState createState() => _PaginaConsultarBobinaState();
}

class _PaginaConsultarBobinaState extends State<PaginaConsultarBobina> {
  bool _bEstaCargado = false;
  String sCodigoBarrasBobina = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Datos misDatos = Datos();
  final formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = FocusNode();
  bool bImprimiendo = false;
  BBDD? _miBBDD;

  _PaginaConsultarBobinaState() {
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  /*Future scanBarcodeNormal() async {
    try {
      sCodigoBarrasBobina = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true, ScanMode.BARCODE);
      if (sCodigoBarrasBobina == "-1") {
        sCodigoBarrasBobina = "";
      }
      setState(() {});

      if (sCodigoBarrasBobina != "") {
        validarCodigoBarras();
      }
    } catch (err) {}
  }

  void validarCodigoBarras() {
  
    if (sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras) {
      mostrarMensaje(true, 'Minimo ' + maximoCaracteresCodigoBarras.toString() + ' caracteres');
      enviarFoco();
    } else {
      //miInterface.dameDatosBobina(misDatos.usuario.token, sCodigoBarrasBobina);
    }
  }*/

  void inicializarVariables() {
    setState(() {
      sCodigoBarrasBobina = "";
      _bEstaCargado = false;
    });
  }

  void enviarFoco() {
    FocusScope.of(context).requestFocus(myFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    void validarFormulario() async {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();

        ProgressDialog.show(context);
        _miBBDD = GetIt.instance<BBDD>();

        final RespuestaHTTP<Bobina> miRespuesta = await _miBBDD!.dameDatosBobina(codigoBobina: sCodigoBarrasBobina);

        ProgressDialog.dissmiss(context);
        misDatos.setBobina(miRespuesta.data!);
        setState(() {
          _bEstaCargado = true;
        });
      } else {
        enviarFoco();
      }
    }

    void imprimirEtiqueta() async {
      setState(() {
        bImprimiendo = true;
      });

      ProgressDialog.show(context);

      final RespuestaHTTP<String> miRespuesta = await _miBBDD!.imprimirBobina(codigoBobina: sCodigoBarrasBobina, impresora: misDatos.usuario.impresoraSeleccionada!);

      ProgressDialog.dissmiss(context);
      setState(() {
        bImprimiendo = false;
      });
      mostrarMensaje(false, miRespuesta.data!);
    }

    Boton cmdConsultarOTRA = Boton(texto: "OTRA BOBINA", pAccion: () => {inicializarVariables()}, alto: responsive.altoPorc(8), ancho: responsive.anchoPorc(36));
    Boton cmdImprimirEtiqueta = Boton(texto: "IMPRIMIR BOBINA", pAccion: () => {imprimirEtiqueta()}, alto: responsive.altoPorc(8), ancho: responsive.anchoPorc(36));
    //RaisedButton cmdConsultarOTRA = botonWidget(context, "OTRA BOBINA", pAccion: () => {inicializarVariables()});

    var loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _bEstaCargado
                  ? SizedBox()
                  : Container(
                      width: (MediaQuery.of(context).size.width * 0.80),
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        focusNode: myFocusNode,
                        onFieldSubmitted: (String key) {
                          validarFormulario();
                        },
                        style: TextStyle(fontSize: 25.0),
                        controller: TextEditingController(text: sCodigoBarrasBobina),
                        onChanged: (value) => sCodigoBarrasBobina = value,
                        validator: (value) {
                          return sCodigoBarrasBobina.length < maximoCaracteresCodigoBarras ? "Minimo $maximoCaracteresCodigoBarras caracteres" : null;
                        },
                        maxLength: maximoCaracteresCodigoBarras,
                        decoration: InputDecoration(
                          labelStyle: miEstiloTextFormField,
                          labelText: "CODIGO BARRAS",
                        ),
                      ),
                    ),
              _bEstaCargado
                  ? ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          //  borderRadius: BorderRadius.circular(15),
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
                        width: responsive.anchoPorc(99),
                        height: responsive.altoPorc(60),
                        child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
                          Label(
                            label: 'Proveedor',
                            valor: misDatos.bobina.nombreProveedor!,
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Nº Bobina',
                            valor: misDatos.bobina.codigoBobina!,
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Cod. Barras',
                            valor: misDatos.bobina.codigoInternoBobina!,
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
                            label: 'Metros Lineales',
                            valor: formatearEntero(misDatos.bobina.longitud!),
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Tipo',
                            valor: "${misDatos.bobina.grupo!} ${misDatos.bobina.articulo}",
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Gramaje',
                            valor: formatearEntero(misDatos.bobina.gramaje!),
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Ancho',
                            valor: formatearEntero(misDatos.bobina.ancho!),
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Estado ',
                            valor: misDatos.bobina.grupoConsumo!.isNotEmpty ? "${misDatos.bobina.estado!} - Brazo: ${misDatos.bobina.grupoConsumo!}" : misDatos.bobina.estado!,
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                          Divider(),
                          Label(
                            label: 'Ubicacion',
                            valor: "${misDatos.bobina.nombreAlmacen!} (${misDatos.bobina.zona!}-${misDatos.bobina.casillero})",
                            fontSize: responsive.diagonalPorc(2),
                            colorLabel: miColorBotones,
                            ancho: responsive.anchoPorc(30),
                          ),
                        ]),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(
          height: responsive.altoPorc(1),
        ),
        //  _bEstaCargado ? SizedBox() : cmdConsultar,
        // _bEstaCargado ? SizedBox() : cmdAbrirCamara,
      ],
    );

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            "CONSULTAR DATOS BOBINA",
            style: miEstiloCabeceraPagina,
          ),
          backgroundColor: miColorFondo,
          iconTheme: IconThemeData(color: miColorBotones),
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: loginForm,
            )),
        persistentFooterButtons: [
          _bEstaCargado
              ? bImprimiendo
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        cmdConsultarOTRA,
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.10),
                        ),
                        cmdImprimirEtiqueta
                      ],
                    )
              : SizedBox(),
        ]);
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
