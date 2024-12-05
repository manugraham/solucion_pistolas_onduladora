import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/usuario.dart';
import 'package:solucion_pistolas_onduladora/src/ficherosAntiguos/excepciones.dart';

class BaseDatos {
  // static final BASE_URL ="http://199.5.84.224:8090/Service1.svc/"; //Nueva ip publica de ondupack
  // static final sBASEURL = "http://10.0.2.2:8088/Service1.svc/";

  Future<Usuario> login(String usuario, String clave) async {
    Usuario miUsuario = Usuario(misImpresoras: List.empty());

    String sUsuarioKey = encryptar(usuario);
    String sClaveKey = encryptar(clave);
    String? sUrl;

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sUrl = miConfiguracion.getString("URL");

    String sCadenaUrl = "${sUrl!}login/usuario/$sUsuarioKey/pass/$sClaveKey";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);

      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["LoginResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]); //return new Usuario(sUsuario: usuario, sClave: clave,sToken: "",sMensajeError: miTipoError.mensaje);
      } else {
        // miUsuario = new Usuario(sUsuario: usuario, sClave: clave, sToken: _miRespuesta["Nombre"], sMensajeError: "");
        return Usuario();
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - login");
    }
  }

  Future<String> imprimirBobina(String token, String codigoBobina, String impresora) async {
    String sToken = token; //encryptar(token);
    String sCodigoBobina = encryptar(codigoBobina);
    String? sBASEURL;

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");

    impresora = encryptar(impresora);

    String sCadenaUrl = "${sBASEURL!}ImprimirBobina/Token/$sToken/CodigoBobina/$sCodigoBobina/Impresora/$impresora";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ImprimirBobinaResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameImpresoras");
    }
  }

  Future<String> imprimirUltimaBobinaGrupo(String token, String grupo, String impresora, String codigoMaquina) async {
    String sToken = token; //encryptar(token);
    String sGrupo = encryptar(grupo);
    String? sBASEURL;

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");

    impresora = encryptar(impresora);
    codigoMaquina = encryptar(codigoMaquina);

    String sCadenaUrl = "${sBASEURL!}ImprimirUltimaBobinaGrupo/Token/$sToken/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$sGrupo/Impresora/$impresora";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ImprimirUltimaBobinaGrupoResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - imprimirUltimaBobinaGrupo");
    }
  }

  Future<List<Bobina>> dameBobinasConsumidasGrupo(String token, String grupo, String codigoMaquina) async {
    String sToken = token;

    List<Bobina> bobinas = <Bobina>[];
    Map<String, dynamic> miJson;
    String? sBASEURL;

    grupo = encryptar(grupo);
    codigoMaquina = encryptar(codigoMaquina);

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();
    sBASEURL = miConfiguracion.getString("URL");

    String sCadenaUrl = "${sBASEURL!}DameBobinasActivasBrazo/Token/$sToken/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["DameBobinasActivasBrazoResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        List<dynamic> misBobinas = json.decode(miRespuesta["Nombre"]);

        for (var i = 0; i < misBobinas.length; i++) {
          miJson = misBobinas[i] as Map<String, dynamic>;

          bobinas.add(Bobina.fromJson(miJson));
        }
      }

      return bobinas;
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameImpresoras");
    }
  }

  Future<List<Bobina>> dameBobinasPulmon(String token, String grupo, String codigoMaquina) async {
    String sToken = token; //encryptar(token);

    List<Bobina> bobinasPulmon = <Bobina>[];
    Map<String, dynamic> miJson;
    String? sBASEURL;
    grupo = encryptar(grupo);
    codigoMaquina = encryptar(codigoMaquina);

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");

    String sCadenaUrl = "${sBASEURL!}DameBobinasPulmon/Token/$sToken/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["DameBobinasPulmonResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        List<dynamic> misBobinas = json.decode(miRespuesta["Nombre"]);

        for (var i = 0; i < misBobinas.length; i++) {
          miJson = misBobinas[i] as Map<String, dynamic>;

          bobinasPulmon.add(Bobina.fromJson(miJson));
        }
      }

      return bobinasPulmon;
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameImpresoras");
    }
  }

  Future<List<String>> dameImpresoras(String token) async {
    String sToken = token; //encryptar(token);

    List<String> impresoras = <String>[];
    Map<String, dynamic> miJson;
    String? sBASEURL;

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");

    String sCadenaUrl = "${sBASEURL!}DameImpresorasDisponibles/Token/$sToken";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["DameImpresorasDisponiblesResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        List<dynamic> misImpresoras = json.decode(miRespuesta["Nombre"]);

        for (var i = 0; i < misImpresoras.length; i++) {
          miJson = misImpresoras[i] as Map<String, dynamic>;

          impresoras.add(miJson['Nombre']);
        }
      }

      return impresoras;
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameImpresoras");
    }
  }

  Future<Usuario> cargarDatosUsuario(String token, String usuario, String pass) async {
    String? sBASEURL;
    String sCodigoAPP = "1";

    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    sCodigoAPP = encryptar(sCodigoAPP);
    String sCadenaUrl = "${sBASEURL!}DameDatosUsuario/Token/$token/CodigoAPP/$sCodigoAPP";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["DameDatosUsuarioResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return Usuario.fromJson(json.decode(miRespuesta["Nombre"]));
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameDatosMaquina");
    }
  }

  Future<Bobina> dameDatosBobina(String token, String codigoBarras) async {
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    codigoBarras = encryptar(codigoBarras.toString());

    String sCadenaUrl = "${sBASEURL!}DameDatosBobina/Token/$token/CodigoBarras/$codigoBarras";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["DameDatosBobinaResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return Bobina.fromJson(json.decode(miRespuesta["Nombre"]));
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameDatosBobina");
    }
  }

  Future<String> refreshToken(String token) async {
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();
    String? sBASEURL;

    sBASEURL = miConfiguracion.getString("URL");

    String sCadenaUrl = "${sBASEURL!}RefreshToken/Token/$token";

    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["RefreshTokenResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - RefreshToken");
    }
  }

  // ignore: missing_return
  Future<String> comprobarGrupo(String token, String grupo, String codigoMaquina) async {
    String sCadena = "0";
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    grupo = encryptar(grupo.toString());
    sCadena = encryptar(sCadena.toString());
    codigoMaquina = encryptar(codigoMaquina.toString());

    String sCadenaUrl = "${sBASEURL!}ProcesoColocarBobinaGrupo/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorOnduladora/$grupo/CodigoBobina/$sCadena";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ProcesoColocarBobinaGrupoResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }

      /*  if (_miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        if (_miRespuesta["Codigo"] == tipoCodigoServicioSesionCaducada) {
          // Datos misDatos = new Datos();

          refreshToken(token).then((String token) {
            // misDatos.usuario.setToken(token);
             comprobarGrupo(token, grupo);         
          }).catchError((error) {
            throw TipoError(_miRespuesta["Codigo"], _miRespuesta["Nombre"]);
          });
        } else {
          throw TipoError(_miRespuesta["Codigo"], _miRespuesta["Nombre"]);
        }
      } else {
        return _miRespuesta["Nombre"];
      }*/
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameDatosBobina");
    }
  }

  Future<String> procesoRecuperarBobina(String token, String grupo, String codigoMaquina) async {
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    grupo = encryptar(grupo.toString());
    codigoMaquina = encryptar(codigoMaquina.toString());

    String sCadenaUrl = "${sBASEURL!}ProcesoRecuperarBobina/Token/$token/CodigoMaquina/$codigoMaquina,GrupoIntroductorMaquina/$grupo";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ProcesoRecuperarBobinaResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameDatosBobina");
    }
  }

  Future<String> procesoRecuperarBobina2(String token, String grupo, String codigoBarras, String codigoMaquina) async {
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    grupo = encryptar(grupo.toString());
    codigoBarras = encryptar(codigoBarras.toString());
    codigoMaquina = encryptar(codigoMaquina.toString());

    String sCadenaUrl = "${sBASEURL!}ProcesoRecuperarBobinasActivas/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo/CodigoBobina/$codigoBarras";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ProcesoRecuperarBobinasActivasResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameDatosBobina");
    }
  }

  Future<Bobina> procesoRetirarBobina(String token, String grupo, String codigoBarras, String impresora, String codigoMaquina) async {
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    grupo = encryptar(grupo.toString());
    codigoBarras = encryptar(codigoBarras.toString());
    impresora = encryptar(impresora.toString());
    codigoMaquina = encryptar(codigoMaquina.toString());

    String sCadenaUrl = "${sBASEURL!}ProcesoRetirarCabo/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo/CodigoBobina/$codigoBarras/Impresora/$impresora";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ProcesoRetirarCaboResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return Bobina.fromJson(json.decode(miRespuesta["Nombre"]));
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - comprobarGrupoRetirarBobina");
    }
  }

  Future<String> procesoColocarBobina(String token, String grupo, String codigoBobina, String codigoMaquina) async {
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    grupo = encryptar(grupo.toString());
    codigoBobina = encryptar(codigoBobina.toString());
    codigoMaquina = encryptar(codigoMaquina.toString());

    String sCadenaUrl = "${sBASEURL!}ProcesoColocarBobinaGrupo/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorOnduladora/$grupo/CodigoBobina/$codigoBobina";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ProcesoColocarBobinaGrupoResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return miRespuesta["Nombre"];
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - dameDatosBobina");
    }
  }

  Future<Bobina> procesoRetirarBobinaRadio(String token, String grupo, String radio, String codigoBarras, String impresora, String codigoMaquina) async {
    String? sBASEURL;
    SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    sBASEURL = miConfiguracion.getString("URL");
    grupo = encryptar(grupo.toString());
    codigoBarras = encryptar(codigoBarras.toString());
    radio = encryptar(radio.toString());
    impresora = encryptar(impresora);
    codigoMaquina = encryptar(codigoMaquina.toString());

    String sCadenaUrl = "${sBASEURL!}ProcesoRetirarBobinaRadio/Token/$token/CodigoMaquina/$codigoMaquina/GrupoIntroductorMaquina/$grupo/Radio/$radio/CodigoBarras/$codigoBarras/Impresora/$impresora";
    final response = await http.get(sCadenaUrl as Uri).catchError((Object onError) {
      throw TipoError(tipoCodigoServicioError, 'No hay conexion con el destino.$sCadenaUrl');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> datos = json.decode(response.body);
      Map<String, dynamic> miRespuesta = json.decode((desencryptar(datos["ProcesoRetirarBobinaRadioResult"])));

      if (miRespuesta["Codigo"] != tipoCodigoServicioCorrecto) {
        throw TipoError(miRespuesta["Codigo"], miRespuesta["Nombre"]);
      } else {
        return Bobina.fromJson(json.decode(miRespuesta["Nombre"]));
      }
    } else {
      throw TipoError(tipoCodigoServicioError, "Error en la llamada al webservice - procesoRetirarBobinaRadio");
    }
  }
}
