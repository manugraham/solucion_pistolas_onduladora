import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/Widget/boton.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Sistema.dart';

class PaginaConfiguracion extends StatefulWidget {
  const PaginaConfiguracion({super.key});

  @override
  _PaginaConfiguracionState createState() => _PaginaConfiguracionState();
}

class _PaginaConfiguracionState extends State<PaginaConfiguracion> {
  final misDatos = Datos();
  String? sUrlServidor;
  String? sUsuario;
  String? sClave;
  String? sNombre;
  final formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool obscureText = true;
  Icon miIconoPassword = Icon(Icons.visibility_off);
  Sistema? miSistema;

  _PaginaConfiguracionState() {
    cargarDatos();
  }

  @override
  void initState() {
    super.initState();
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
      if (obscureText) {
        miIconoPassword = Icon(Icons.visibility_off);
      } else {
        miIconoPassword = Icon(Icons.visibility);
      }
    });
  }

  void cargarDatos() async {
    miSistema = GetIt.instance<Sistema>();

    await miSistema!.fromSecure();

    //habria que cifrar estos datos
    sUrlServidor = miSistema?.url;
    sUsuario = miSistema?.usuario;

    sClave = miSistema?.clave;
    sNombre = miSistema?.nombre;

    /*if (sUrlServidor == null) {
      sUrlServidor = "";
      sUsuario = "";
      sClave = "";
      sNombre = "";
    }*/
  }

  void guardarDatos() {
    //SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    miSistema = Sistema(nombre: sNombre, url: sUrlServidor!, usuario: sUsuario, clave: sClave);
    miSistema?.guardar();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

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
                width: responsive.anchoPorc(80), //(MediaQuery.of(context).size.width * 0.80),
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  style: TextStyle(fontSize: responsive.diagonalPorc(2.0)),
                  autofocus: true,
                  controller: TextEditingController(text: '$sNombre'),
                  onChanged: (value) => sNombre = value,
                  onSaved: (val) => sNombre = val,
                  validator: (val) {
                    return val!.length < 5 ? "Minimo 5 caracteres" : null;
                  },
                  maxLength: 50,
                  decoration: InputDecoration(labelStyle: miEstiloTextFormField, labelText: "Nombre"),
                ),
              ),
              Container(
                width: responsive.anchoPorc(80),
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(fontSize: responsive.diagonalPorc(2.0)),
                  controller: TextEditingController(text: '$sUrlServidor'),
                  onChanged: (value) => sUrlServidor = value,
                  onSaved: (val) => sUrlServidor = val,
                  validator: (val) {
                    return val!.length < 5 ? "Minimo 5 caracteres" : null;
                  },
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelStyle: miEstiloTextFormField,
                    labelText: "URL Servidor",
                  ),
                ),
              ),
              Container(
                width: responsive.anchoPorc(80),
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(fontSize: responsive.diagonalPorc(2.0)),
                  controller: TextEditingController(text: '$sUsuario'),
                  onChanged: (value) => sUsuario = value,
                  onSaved: (val) => sUsuario = val,
                  validator: (val) {
                    return val!.length < 3 ? "Minimo 5 caracteres" : null;
                  },
                  maxLength: 15,
                  decoration: InputDecoration(
                    labelStyle: miEstiloTextFormField,
                    labelText: "Usuario",
                  ),
                ),
              ),
              Container(
                width: responsive.anchoPorc(80),
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(text: '$sClave'),
                  style: TextStyle(fontSize: responsive.diagonalPorc(2.0)),
                  obscureText: obscureText,
                  maxLength: 10,
                  onChanged: (valor) => sClave = valor,
                  onSaved: (valor) => sClave = valor,
                  validator: (val) {
                    return val!.length < 3 ? "Minimo 5 caracteres" : null;
                  },
                  decoration: InputDecoration(
                      labelStyle: miEstiloTextFormField,
                      labelText: "Clave",
                      suffixIcon: IconButton(
                          icon: miIconoPassword,
                          onPressed: () {
                            _toggle();
                          })),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Boton(texto: "GUARDAR", pAccion: () => {guardarDatos()}, ancho: responsive.anchoPorc(40), alto: responsive.altoPorc(10)), //botonWidget(context, "GUARDAR", pAccion: () => {guardarDatos()}); cmdGuardar,
            ],
          ),
        ),
        // _bEstaCargado ? new CircularProgressIndicator() : cmdGuardar
      ], // CrossAxisAlignment.center,
    );

    return Scaffold(
        appBar: dameAppBar(titulo: "Datos conexion"),
        key: scaffoldKey,
        // resizeToAvoidBottomInset: false,
        body: Container(
            color: Colors.white,
            child: Center(
                child: SingleChildScrollView(
              child: loginForm,
            ))));
  }
}
