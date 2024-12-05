import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/responsive.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Datos.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';

// ignore: must_be_immutable
class PaginaElegirBobinas extends StatefulWidget {
  OpcionesElegirBobinas? miOpcion;

  PaginaElegirBobinas({super.key, this.miOpcion});

  @override
  _PaginaElegirBobinasState createState() => _PaginaElegirBobinasState();
}

class _PaginaElegirBobinasState extends State<PaginaElegirBobinas> {
  final misDatos = Datos();
  List<Bobina> misBobinas = <Bobina>[];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  BBDD? _miBBDD;

  bool _bCargado = false;

  @override
  void initState() {
    super.initState();

    buscarBobinas();
  }

  void buscarBobinas() async {
    // ProgressDialog.show(context);
    _miBBDD = GetIt.instance<BBDD>();

    switch (widget.miOpcion) {
      case OpcionesElegirBobinas.BobinasRecuperadasGrupo:
        {
          final RespuestaHTTP<List<Bobina>> miRespuesta = await _miBBDD!.dameBobinasRecuperadasGrupo(codigoMaquina: misDatos.usuario.miMaquinaSeleccionada!.codigo.toString(), grupo: misDatos.grupo);

          misBobinas = miRespuesta.data!;
          _bCargado = true;
          setState(() {});
        }
        break;
      case OpcionesElegirBobinas.BobinasEnPulmon:
        {
          final RespuestaHTTP<List<Bobina>> miRespuesta = await _miBBDD!.dameBobinasPulmon(grupo: misDatos.grupo);

          misBobinas = miRespuesta.data!;
          _bCargado = true;
          setState(() {});
          //  ProgressDialog.dissmiss(context);
        }
        break;
      case OpcionesElegirBobinas.BobinasConsumidasGrupo:
        {
          final RespuestaHTTP<List<Bobina>> miRespuesta = await _miBBDD!.dameBobinasConsumidasGrupo(grupo: misDatos.grupo);
          misBobinas = miRespuesta.data!;

          _bCargado = true;
          setState(() {});
          // ProgressDialog.dissmiss(context);
        }
        break;
      default:
        {}
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    Widget mostrarRegistroBobina(Bobina bobina) {
      return Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: responsive.anchoPorc((10.0))),
            title: Text(bobina.codigoInternoBobina!),
            subtitle: Text('${bobina.grupo!} - ${bobina.articulo} - ${bobina.fechaUltimoMovimiento}'),
            leading: Icon(
              Icons.battery_std,
              color: miColorFondo,
            ),
            onTap: () {
              misDatos.setCodigoBobina(bobina.codigoInternoBobina);
              Navigator.pop(context, bobina.codigoInternoBobina);
            },
          ),
          Divider()
        ],
      );
    }

    return Scaffold(
      appBar: dameAppBar(titulo: "BOBINAS ENCONTRADAS"),
      body: !_bCargado
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 8.0,
              ),
            )
          : misBobinas.isEmpty
              ? Center(
                  child: Text("No hay bobinas"),
                )
              : ListView(
                  children: misBobinas.map(mostrarRegistroBobina).toList(),
                ),
    );
  }

  void mostrarMensaje(bool error, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(dameSnackBar(titulo: texto, error: error));
  }
}
