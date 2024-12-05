import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/Http.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/RespuestaHTTP.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Sesion.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/usuario.dart';

class BBDD {
  final Http _http;

  BBDD(this._http);

  Future<RespuestaHTTP<Sesion>> login({String? usuario, String? clave}) {
    String sUsuarioKey = encryptar(usuario!);
    String sClaveKey = encryptar(clave!);

    return _http.respuesta<Sesion>("/login/usuario/$sUsuarioKey/pass/$sClaveKey", metodo: "GET", cadenaResultado: "LoginResult", parser: (datos) {
      Sesion miSesion = Sesion.fromJson(datos.first);
      return miSesion;
    });
  }

  Future<RespuestaHTTP<Usuario>> dameInformacionUsuario() async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    String sCodigoAPP = "1";
    sCodigoAPP = encryptar(sCodigoAPP);

    return _http.respuesta<Usuario>("/DameDatosUsuario/Token/$token/CodigoAPP/$sCodigoAPP", metodo: "GET", cadenaResultado: "DameDatosUsuarioResult", parser: (datos) {
      return Usuario.fromJson(datos.first);
    });
  }

  Future<RespuestaHTTP<List<Bobina>>> dameBobinasPulmon({required String grupo}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Bobina> bobinasPulmon = <Bobina>[];

    grupo = encryptar(grupo);

    return _http.respuesta<List<Bobina>>("/DameBobinasPulmon/Token/$token/GrupoIntroductorMaquina/$grupo", metodo: "GET", cadenaResultado: "DameBobinasPulmonResult", parser: (datos) {
      List<dynamic> misBobinas = datos;

      for (var i = 0; i < misBobinas.length; i++) {
        bobinasPulmon.add(Bobina.fromJson(misBobinas[i] as Map<String, dynamic>));
      }

      return bobinasPulmon;
    });
  }

  Future<RespuestaHTTP<List<Bobina>>> dameBobinasRecuperadasGrupo({required String grupo, required String codigoMaquina}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Bobina> bobinasRecuperadas = <Bobina>[];

    grupo = encryptar(grupo);
    codigoMaquina = encryptar(codigoMaquina);

    return _http.respuesta<List<Bobina>>("/DameUltimasBobinasRecuperadasGrupo/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo", metodo: "GET", cadenaResultado: "DameUltimasBobinasRecuperadasGrupoResult", parser: (datos) {
      List<dynamic> misBobinas = datos;

      for (var i = 0; i < misBobinas.length; i++) {
        bobinasRecuperadas.add(Bobina.fromJson(misBobinas[i] as Map<String, dynamic>));
      }

      return bobinasRecuperadas;
    });
  }

  Future<RespuestaHTTP<List<Bobina>>> dameBobinasConsumidasGrupo({required String grupo}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    List<Bobina> bobinasConsumidas = <Bobina>[];

    grupo = encryptar(grupo);

    return _http.respuesta<List<Bobina>>("/DameBobinasActivasBrazo/Token/$token/GrupoIntroductorMaquina/$grupo", metodo: "GET", cadenaResultado: "DameBobinasActivasBrazoResult", parser: (datos) {
      List<dynamic> misBobinas = datos;

      for (var i = 0; i < misBobinas.length; i++) {
        bobinasConsumidas.add(Bobina.fromJson(misBobinas[i] as Map<String, dynamic>));
      }

      return bobinasConsumidas;
    });
  }

  Future<RespuestaHTTP<Sesion>> refreshToken({required String tokenExpirado}) {
    return _http.respuesta<Sesion>("/RefreshToken/Token/$tokenExpirado", metodo: "GET", cadenaResultado: "RefreshTokenResult", parser: (datos) {
      return Sesion.fromJson(datos.first);
    });
  }

  Future<RespuestaHTTP<Bobina>> dameDatosBobina({required String codigoBobina}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    codigoBobina = encryptar(codigoBobina);

    return _http.respuesta<Bobina>("/DameDatosBobina/Token/$token/CodigoBarras/$codigoBobina", metodo: "GET", cadenaResultado: "DameDatosBobinaResult", parser: (datos) {
      return Bobina.fromJson(datos.first);
    });
  }

  Future<RespuestaHTTP<String>> imprimirBobina({required String codigoBobina, required String impresora}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    codigoBobina = encryptar(codigoBobina);
    impresora = encryptar(impresora);

    return _http.respuesta<String>("/ImprimirBobina/Token/$token/CodigoBobina/$codigoBobina/Impresora/$impresora", metodo: "GET", cadenaResultado: "ImprimirBobinaResult");
  }

  Future<RespuestaHTTP<String>> imprimirUltimaBobinaGrupo({required String grupo, required String impresora}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    grupo = encryptar(grupo);
    impresora = encryptar(impresora);

    return _http.respuesta<String>("/ImprimirUltimaBobinaGrupo/Token/$token/GrupoIntroductorMaquina/$grupo/Impresora/$impresora", metodo: "GET", cadenaResultado: "ImprimirUltimaBobinaGrupoResult");
  }

  Future<RespuestaHTTP<String>> comprobarGrupo({required String grupo}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;
    String sCadena = "0";

    grupo = encryptar(grupo);
    sCadena = encryptar(sCadena.toString());

    return _http.respuesta<String>("/ProcesoColocarBobinaGrupo/Token/$token/GrupoIntroductorOnduladora/$grupo/CodigoBobina/$sCadena", metodo: "GET", cadenaResultado: "ProcesoColocarBobinaGrupoResult");
  }

  Future<RespuestaHTTP<String>> colocarBobina({required String grupo, required String codigoBobina}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;

    grupo = encryptar(grupo);
    codigoBobina = encryptar(codigoBobina.toString());

    return _http.respuesta<String>("/ProcesoColocarBobinaGrupo/Token/$token/GrupoIntroductorOnduladora/$grupo/CodigoBobina/$codigoBobina", metodo: "GET", cadenaResultado: "ProcesoColocarBobinaGrupoResult");
  }

  Future<RespuestaHTTP<Bobina>> retirarBobina({required String grupo, required String codigoBarras, required String impresora}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    grupo = encryptar(grupo);
    codigoBarras = encryptar(codigoBarras);
    impresora = encryptar(impresora);

    return _http.respuesta<Bobina>("/ProcesoRetirarCabo/Token/$token/GrupoIntroductorMaquina/$grupo/CodigoBobina/$codigoBarras/Impresora/$impresora", metodo: "GET", cadenaResultado: "ProcesoRetirarCaboResult", parser: (datos) {
      return Bobina.fromJson(datos.first);
    });
  }

  Future<RespuestaHTTP<String>> recuperarBobina({required String grupo, required String codigoBarras, required String codigoMaquina}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();
    final token = await miSesion.accessToken;

    grupo = encryptar(grupo);
    codigoBarras = encryptar(codigoBarras);
    codigoMaquina = encryptar(codigoMaquina);

    return _http.respuesta<String>("/ProcesoRecuperarBobinasActivas/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo/CodigoBobina/$codigoBarras", metodo: "GET", cadenaResultado: "ProcesoRecuperarBobinasActivasResult");
  }

  Future<RespuestaHTTP<Bobina>> retirarBobinaRadio({required String grupo, required String codigoBarras, required String radio, required String impresora}) async {
    final Sesion miSesion = GetIt.instance<Sesion>();

    final token = await miSesion.accessToken;

    grupo = encryptar(grupo);
    radio = encryptar(radio);
    codigoBarras = encryptar(codigoBarras);
    impresora = encryptar(impresora);

    return _http.respuesta<Bobina>("/ProcesoRetirarBobinaRadio/Token/$token/GrupoIntroductorMaquina/$grupo/Radio/$radio/CodigoBarras/$codigoBarras/Impresora/$impresora", metodo: "GET", cadenaResultado: "ProcesoRetirarBobinaRadioResult",
        parser: (datos) {
      return Bobina.fromJson(datos.first);
    });
  }
}
