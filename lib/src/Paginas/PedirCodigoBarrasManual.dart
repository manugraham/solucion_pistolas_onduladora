import 'package:flutter/material.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';

class PaginaCodigoBarrasManual extends StatefulWidget {
  const PaginaCodigoBarrasManual({super.key});

  @override
  _PaginaCodigoBarrasManualState createState() => _PaginaCodigoBarrasManualState();
}

class _PaginaCodigoBarrasManualState extends State<PaginaCodigoBarrasManual> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String sCodigoBarras = "";
    FocusNode miFoco = FocusNode();

    void enviarFoco() {
      FocusScope.of(context).requestFocus(miFoco);
    }

    void validarCodigoBarras() {
      if (sCodigoBarras.length < maximoCaracteresCodigoBarras) {
        mostrarMensaje(true, 'Minimo $maximoCaracteresCodigoBarras caracteres');
        enviarFoco();
      } else {
        if (sCodigoBarras.isEmpty) {
          mostrarMensaje(true, 'Debe introducir un codigo de barras');
          enviarFoco();
        } else {
          Navigator.pop(context, sCodigoBarras);
        }
      }
    }

    return Scaffold(
        appBar: dameAppBar(titulo: "COD. BARRAS MANUAL"),
        body: Center(
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.80),
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.none,
              autofocus: true,
              focusNode: miFoco,
              onFieldSubmitted: (String key) {
                validarCodigoBarras();
              },
              controller: TextEditingController(text: sCodigoBarras),
              onChanged: (value) => sCodigoBarras = value,
              validator: (value) {
                return sCodigoBarras.length < maximoCaracteresCodigoBarras ? "Minimo $maximoCaracteresCodigoBarras caracteres" : null;
              },
              maxLength: maximoCaracteresCodigoBarras,
              decoration: InputDecoration(
                labelStyle: miEstiloTextFormField,
                labelText: "Codigo de barras OC",
              ),
            ),
          ),
        ));
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
