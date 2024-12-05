import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/Logs.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'RespuestaHTTP.dart';

class Http {
  final Dio _dio;

  Http({required Dio dio}) : _dio = dio;

  Future<RespuestaHTTP<T>> respuesta<T>(String path, {String metodo = "GET", String? cadenaResultado, Map<String, dynamic>? parametros, Map<String, dynamic>? datos, Map<String, String>? cabeceras, T Function(List<dynamic> datos)? parser}) async {
    try {
      final response = await _dio.request(
        path,
        options: Options(method: metodo, headers: cabeceras),
        queryParameters: parametros,
        data: datos,
      );

      Logs.log.i(response.data);

      if (cadenaResultado != null && response.data != null) {
        Map<String, dynamic> miRespuesta = json.decode((desencryptar(response.data[cadenaResultado])));
        if (miRespuesta['Codigo'] != tipoCodigoServicioCorrecto) {
          return RespuestaHTTP.inCorrecto(codigo: miRespuesta['Codigo'], mensaje: miRespuesta['Nombre'], datos: miRespuesta);
        } else {
          List<dynamic> misDatos = json.decode(miRespuesta['Nombre']);
          return RespuestaHTTP.correcto<T>(parser!(misDatos));
        }
      } else {
        dynamic datosError;
        return RespuestaHTTP.inCorrecto(codigo: "-1", mensaje: "la respuesta es nula", datos: datosError);
      }
      //  Map<String, dynamic> _datos = json.decode(response.data);
    } catch (error) {
      Logs.log.e(error);

      String? codigoError = '0';
      String? mensajeError = 'Error desconocido';
      dynamic datosError;

      if (error is DioException) {
        mensajeError = error.message;
        codigoError = '-1';
        codigoError = error.response?.statusCode.toString() ?? "-1";
        mensajeError = error.response?.statusMessage ?? mensajeError;
        datosError = error.response?.data;
      }
      return RespuestaHTTP.inCorrecto(codigo: codigoError, mensaje: mensajeError, datos: datosError);
    }
  }
}
