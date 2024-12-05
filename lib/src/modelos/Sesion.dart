import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Logs.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/data/API/BBDD.dart';

class Sesion {
  String? token;
  int? segundosExpiracion;
  DateTime? fecha;
  String? usuario;

  final FlutterSecureStorage? secureStorage;

  Completer? _completer;

  Sesion({
    required this.token,
    required this.segundosExpiracion,
    required this.fecha,
    required this.usuario,
    this.secureStorage,
  });

  static Sesion fromJson(Map<String, dynamic> json) {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    return Sesion(token: json['Token'], segundosExpiracion: json['SegundosExpiracion'], fecha: DateTime.parse(json['Fecha']), usuario: json['Usuario'], secureStorage: secureStorage);
  }

  Map<String, dynamic> toJson() {
    return {"Token": token, "SegundosExpiracion": segundosExpiracion, "Fecha": fecha?.toIso8601String(), "Usuario": usuario};
  }

  Future<void> saveSession() async {
    final data = jsonEncode(toJson());

    await secureStorage?.write(key: 'SESSION', value: data);
  }

  Future<void> closeSession() async {
    secureStorage?.delete(key: 'SESSION');
  }

  void _completo() {
    if (!_completer!.isCompleted) {
      _completer?.complete();
    }
  }

  Future<String?> get accessToken async {
    await _completer?.future;

    _completer = Completer(); //esto hace que solo se ejecute una vez en el caso de que se hagan varias llamadas.

    final data = await secureStorage?.read(key: 'SESSION');

    fromJson(jsonDecode(data!));

    final DateTime fechaActual = DateTime.now();
    final DateTime? fechaSesion = fecha;

    final diff = fechaActual.difference(fechaSesion!).inSeconds;

    Logs.log.i("Segundos sesion: ${segundosExpiracion! - diff}");

    if (segundosExpiracion! - diff > segundosMinimosConexion) {
      _completo();
      return token;
    } else {
      final miBBDD = GetIt.instance<BBDD>();
      final response = await miBBDD.refreshToken(tokenExpirado: token!);
      if (response.data != null) {
        token = response.data?.token;
        segundosExpiracion = response.data?.segundosExpiracion;
        fecha = response.data?.fecha;
        usuario = response.data?.usuario;

        await saveSession();
        _completo();
        return response.data?.token;
      } else {
        _completo();
        return null;
      }
    }
  }
}
