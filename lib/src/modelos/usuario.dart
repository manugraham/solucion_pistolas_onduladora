import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Maquina.dart';

import 'SociedadUsuario.dart';

class Usuario {
  int? iCodigo;
  String? sUsuario;
  // String sClave;
  String? sNombre;
  String? sEmail;
  int? iCodigoComercial;
  int? iCodigoCliente;
  int? iCodigoAlmacen;
  // String sToken;
  String? sMensajeError;
  String? sNombreCliente;
  String? sNombreComercial;
  String? sNombreCentroMontaje;
  int? iVersionAPP;
  String? sRutaActualizacionAPP;
  String? sRutaDocumentacionAPP;

  SociedadUsuario? miSociedadSeleccionada;
  List<SociedadUsuario>? misSociedades;
  List<String>? misImpresoras = List.empty();
  List<Maquina>? misMaquinas = List.empty();
  String? sImpresoraSeleccionada;
  Maquina? miMaquinaSeleccionada;
  bool? bCreado;

  Usuario.origin() {
    iCodigo = 0;
    sUsuario = "";
    // sClave = "";
    sNombre = "";
    sEmail = "";
    iCodigoComercial = 0;
    iCodigoCliente = 0;
    iCodigoAlmacen = 0;
    // sToken = "";
    sMensajeError = "";
    sNombreCliente = "";
    sNombreComercial = "";
    sNombreCentroMontaje = "";
    iVersionAPP = 0;
    miSociedadSeleccionada = SociedadUsuario();
    misSociedades = <SociedadUsuario>[];
    misImpresoras = <String>[];
    misMaquinas = <Maquina>[];
    sImpresoraSeleccionada = "";
    miMaquinaSeleccionada = Maquina();
    sRutaActualizacionAPP = "";
    sRutaDocumentacionAPP = "";
    bCreado = false;
  }

  Usuario(
      {this.iCodigo,
      this.sUsuario,
      // this.sClave,
      //this.sToken,
      this.sNombre,
      this.iCodigoComercial,
      this.iCodigoCliente,
      this.iCodigoAlmacen,
      this.sMensajeError,
      this.misSociedades,
      this.sNombreCliente,
      this.sNombreComercial,
      this.sNombreCentroMontaje,
      this.sEmail,
      this.misImpresoras,
      this.sImpresoraSeleccionada,
      this.miSociedadSeleccionada,
      this.iVersionAPP,
      this.sRutaActualizacionAPP,
      this.sRutaDocumentacionAPP,
      this.bCreado,
      this.misMaquinas,
      this.miMaquinaSeleccionada});

  void setImpresoraSeleccionada(String impresora) async {
    if (misImpresoras!.where((imp) => imp == impresora).toList().isNotEmpty) {
      sImpresoraSeleccionada = misImpresoras?.where((imp) => imp == impresora).toList().first;

      SharedPreferences miConfiguracion = await SharedPreferences.getInstance();
      miConfiguracion.setString("Impresora", sImpresoraSeleccionada!);
    } else {
      sImpresoraSeleccionada = "";
    }
  }

  void setMaquinaSeleccionada(int? maquina) async {
    if (misMaquinas!.where((maq) => maq.codigo == maquina).toList().isNotEmpty) {
      miMaquinaSeleccionada = misMaquinas?.where((maq) => maq.codigo == maquina).toList().first;
    } else {
      miMaquinaSeleccionada = Maquina();
    }
  }

  void setSociedadSeleccionada(int sociedad) {
    if (misSociedades!.where((soc) => soc.codigo == sociedad).toList().isNotEmpty) {
      miSociedadSeleccionada = misSociedades?.where((soc) => soc.codigo == sociedad).toList().first;
    } else {
      miSociedadSeleccionada = SociedadUsuario();
    }
  }

  bool get usuarioNormal {
    if (iCodigoCliente == 0 && iCodigoComercial == 0 && iCodigoAlmacen == 0) {
      return true;
    } else {
      return false;
    }
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    List<SociedadUsuario> sociedades = <SociedadUsuario>[];
    List<String> impresoras = <String>[];
    List<Maquina> maquinas = <Maquina>[];
    List<dynamic> sociedadesJson = json['Sociedades'];
    List<dynamic> impresorasJson = json['Impresoras'];
    List<dynamic> maquinasJson = json['Maquinas'];

    for (var i = 0; i < impresorasJson.length; i++) {
      impresoras.add(impresorasJson[i]['Nombre']);
    }

    for (var i = 0; i < sociedadesJson.length; i++) {
      sociedades.add(SociedadUsuario.fromJson(sociedadesJson[i]));
    }

    for (var i = 0; i < maquinasJson.length; i++) {
      maquinas.add(Maquina.fromJson(maquinasJson[i]));
    }

    return Usuario(
      iCodigo: json['Codigo'] as int,
      sUsuario: json['Usuario'] as String,
      // sClave: pass,
      //sToken: token,
      sNombre: json['Nombre'] as String,
      iCodigoComercial: json['CodigoComercial'] as int,
      iCodigoCliente: json['CodigoCliente'] as int,
      iCodigoAlmacen: json['CodigoCentroMontaje'] as int,
      misSociedades: sociedades,
      sNombreCliente: json['NombreCliente'] as String,
      sNombreComercial: json['NombreComercial'] as String,
      sNombreCentroMontaje: json['NombreCentroMontaje'] as String,
      sEmail: json['Email'] as String,
      misImpresoras: impresoras,
      bCreado: true,
      sImpresoraSeleccionada: "",
      iVersionAPP: json['VersionAPP'] as int,
      sRutaActualizacionAPP: json['RutaActualizacion'] as String,
      sRutaDocumentacionAPP: json['RutaDocumentacion'] as String,
      misMaquinas: maquinas,
      miSociedadSeleccionada: SociedadUsuario(),
      miMaquinaSeleccionada: Maquina(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Usuario": sUsuario,
      "Codigo": iCodigo,
      "Nombre": sNombre,
      "CodigoComercial": iCodigoComercial,
      "CodigoCliente": iCodigoCliente,
      "CodigoCentroMontaje": iCodigoAlmacen,
      "Sociedades": misSociedades,
      "NombreCliente": sNombreCliente,
      "NombreComercial": sNombreComercial,
      "NombreCentroMontaje": sNombreCentroMontaje,
      "Email": sEmail,
      "ImpresoraSeleccionada": sImpresoraSeleccionada,
      "VersionAPP": iVersionAPP,
      "RutaActualizacion": sRutaActualizacionAPP,
      "RutaDocumentacion": sRutaDocumentacionAPP,
      "Maquinas": misMaquinas
    };
  }

  int? get codigo => iCodigo;
  String? get username => sUsuario;
  String? get nombre => sNombre;
  int? get codigoComercial => iCodigoComercial;
  int? get codigoCliente => iCodigoCliente;
  int? get codigoCentroMontaje => iCodigoAlmacen;
  String? get nombreCliente => sNombreCliente;
  String? get nombreComercial => sNombreComercial;
  String? get nombreCentroMontaje => sNombreCentroMontaje;
  String? get email => sEmail!.trim();
  String? get mensajeError => sMensajeError;
  SociedadUsuario? get sociedadSeleccionada => miSociedadSeleccionada;
  bool get creado => bCreado!;
  String? get impresoraSeleccionada => sImpresoraSeleccionada;
  int? get versionAPPActual => iVersionAPP;
  String get rutaActualizacionAPP => sRutaActualizacionAPP!;
  String get rutaDocumentacionAPP => sRutaDocumentacionAPP!;

  List<Maquina>? get getMaquinas => misMaquinas;

  List<String> get getImpresoras {
    return misImpresoras!;
  }

  List<SociedadUsuario>? get getSociedades => misSociedades;

  void addImpresora(String impresora) {
    misImpresoras!.add(impresora);
  }

  void addSociedad(SociedadUsuario sociedad) {
    misSociedades!.add(sociedad);
  }

  void addMaquina(Maquina maquina) {
    misMaquinas!.add(maquina);
  }

  Widget asociado() {
    if (iCodigoCliente! > 0) {
      return labelBox("Cliente", nombreCliente!, 100, 25, Alignment.centerLeft);
    } else {
      if (iCodigoComercial! > 0) {
        return labelBox("Comercial", nombreComercial!, 20, 20, Alignment.centerLeft);
      } else {
        if (iCodigoAlmacen! > 0) {
          return labelBox("Almacen", nombreCentroMontaje!, 20, 20, Alignment.centerLeft);
        } else {
          return Text("");
        }
      }
    }
  }
}
