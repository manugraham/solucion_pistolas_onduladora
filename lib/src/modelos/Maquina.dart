import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Maquina {
  int? codigo;
  String? nombre;
  final FlutterSecureStorage? secureStorage;

  Maquina({
    this.codigo,
    this.nombre,
    this.secureStorage,
  });

  static Maquina fromJson(Map<String, dynamic> json) {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    return Maquina(codigo: json['Codigo'], nombre: json['Nombre'], secureStorage: secureStorage);
  }

  Map<String, dynamic> toJson() {
    return {"Codigo": codigo, "Nombre": nombre};
  }

  Future<void> saveMaquina() async {
    final data = jsonEncode(toJson());

    await secureStorage?.write(key: 'MAQUINA', value: data);
  }

  Future<void> closeMaquina() async {
    secureStorage?.delete(key: 'MAQUINA');
  }
}
