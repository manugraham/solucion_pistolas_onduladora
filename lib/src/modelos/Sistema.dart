import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Sistema {
  String? nombre;
  String url;
  String? usuario;
  String? clave;

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Sistema({required this.nombre, required this.url, required this.usuario, required this.clave});

  static Sistema fromJson(Map<String, dynamic> json) {
    return Sistema(nombre: json['nombre'], url: json['url'], usuario: json['usuario'], clave: json['clave']);
  }

  Map<String, dynamic> toJson() {
    return {"nombre": nombre, "url": url, "usuario": usuario, "clave": clave};
  }

  Future<void> guardar() async {
    final data = jsonEncode(toJson());

    await secureStorage.write(key: 'SISTEMA', value: data);
  }

  Future<void> fromSecure() async {
    final datosSeguros = await secureStorage.read(key: 'SISTEMA');
    final Map<String, dynamic> misDatos = jsonDecode(datosSeguros!);
    nombre = misDatos['nombre'] as String;
    url = misDatos['url'] as String;
    clave = misDatos['clave'] as String;
    usuario = misDatos['usuario'] as String;
  }

  Future<void> cerrar() async {
    secureStorage.delete(key: 'SISTEMA');
  }
}
