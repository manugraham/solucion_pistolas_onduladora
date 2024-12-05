import 'package:solucion_pistolas_onduladora/src/ficherosAntiguos/BaseDatos.dart';
import 'package:solucion_pistolas_onduladora/src/ficherosAntiguos/excepciones.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/usuario.dart';

abstract class InterfaceContract {
  void onCorrecto(dynamic datos);
  void onError(TipoError datosError);
  void mostrarMensaje(bool error, String texto);
}

class InterfacePresenter {
  InterfaceContract miPagina;
  BaseDatos miBaseDatos = BaseDatos();
  InterfacePresenter(this.miPagina);

  login(String username, String password) {
    miBaseDatos.login(username, password).then((Usuario user) {
      miPagina.onCorrecto(user);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  cargarDatosUsuario(Usuario usuario) {
    /* miBaseDatos.cargarDatosUsuario(usuario.token, usuario.username, usuario.password).then((Usuario usuario) {
      miPagina.onCorrecto(usuario);
    }).catchError((Object error) {
      miPagina.onError((error));
    });*/
  }

  dameDatosBobina(String token, String codigoBarras) {
    miBaseDatos.dameDatosBobina(token, codigoBarras).then((Bobina bobina) {
      miPagina.onCorrecto(bobina);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  comprobarGrupo(String token, String grupo, String codigoMaquina) {
    miBaseDatos.comprobarGrupo(token, grupo, codigoMaquina).then((String datos) {
      miPagina.onCorrecto(datos);
    }).catchError((error) {
      miPagina.onError((error));
    });
  }

  procesoRecuperarBobina(String token, String grupo, String codigoMaquina) {
    miBaseDatos.procesoRecuperarBobina(token, grupo, codigoMaquina).then((String datos) {
      miPagina.onCorrecto(datos);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  procesoRecuperarBobina2(String token, String grupo, String codigoBarras, String codigoMaquina) {
    miBaseDatos.procesoRecuperarBobina2(token, grupo, codigoBarras, codigoMaquina).then((String datos) {
      miPagina.onCorrecto(datos);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  comprobarGrupoRetirarBobina(String token, String grupo, String codigoMaquina) {
    miBaseDatos.procesoRetirarBobina(token, grupo, "0", "0", codigoMaquina).then((Bobina bobina) {
      miPagina.onCorrecto(bobina);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  comprobarDatosRetirarBobinaRadio(String token, String grupo, String radio, String codigoMaquina) {
    miBaseDatos.procesoRetirarBobinaRadio(token, grupo, radio, "0", "0", codigoMaquina).then((Bobina bobina) {
      miPagina.onCorrecto(bobina);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  procesoRetirarBobinaRadio(String token, String grupo, String radio, String codigoBarras, String impresora, String codigoMaquina) {
    miBaseDatos.procesoRetirarBobinaRadio(token, grupo, radio, codigoBarras, impresora, codigoMaquina).then((Bobina bobina) {
      miPagina.onCorrecto(bobina);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  procesoRetirarBobina(String token, String grupo, String codigoBarras, String impresora, String codigoMaquina) {
    miBaseDatos.procesoRetirarBobina(token, grupo, codigoBarras, impresora, codigoMaquina).then((Bobina bobina) {
      miPagina.onCorrecto(bobina);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  cargarImpresoras(String token) {
    miBaseDatos.dameImpresoras(token).then((List<String> impresoras) {
      miPagina.onCorrecto(impresoras);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  imprimirBobina(String token, String codigoBobina, String impresora) {
    miBaseDatos.imprimirBobina(token, codigoBobina, impresora).then((String mensaje) {
      miPagina.onCorrecto(mensaje);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  imprimirUltimaBobinaGrupo(String token, String grupo, String impresora, String codigoMaquina) {
    miBaseDatos.imprimirUltimaBobinaGrupo(token, grupo, impresora, codigoMaquina).then((String mensaje) {
      miPagina.onCorrecto(mensaje);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  procesoColocarBobina(String token, String grupo, String codigoBobina, String codigoMaquina) {
    miBaseDatos.procesoColocarBobina(token, grupo, codigoBobina, codigoMaquina).then((String mensaje) {
      miPagina.onCorrecto(mensaje);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  dameBobinasPulmon(String token, String grupo, String codigoMaquina) {
    miBaseDatos.dameBobinasPulmon(token, grupo, codigoMaquina).then((List<Bobina> bobinas) {
      miPagina.onCorrecto(bobinas);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }

  dameBobinasConsumidasGrupo(String token, String grupo, String codigoMaquina) {
    miBaseDatos.dameBobinasConsumidasGrupo(token, grupo, codigoMaquina).then((List<Bobina> bobinas) {
      miPagina.onCorrecto(bobinas);
    }).catchError((dynamic error) {
      miPagina.onError((error));
    });
  }
}
