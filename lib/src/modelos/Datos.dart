import 'package:solucion_pistolas_onduladora/src/modelos/Bobina.dart';
import 'package:solucion_pistolas_onduladora/src/modelos/usuario.dart';

class Datos {
  static final Datos _singleton = Datos._internal();
  Usuario miUsuario = Usuario.origin();
  Bobina miBobina = Bobina();
  String _sGrupo = "";
  String _sCodigoBobina = "";

  Bobina get bobina => miBobina;
  Usuario get usuario => miUsuario;
  String get grupo => _sGrupo;
  String get codigoBobina => _sCodigoBobina;

  void setCodigoBobina(codigoBobina) {
    _sCodigoBobina = codigoBobina;
  }

  void setBobina(Bobina bobina) {
    miBobina = bobina;
  }

  void setGrupo(String grupo) {
    _sGrupo = grupo;
  }

  void setUsuario(Usuario user) async {
    try {
      miUsuario = user;
      //   SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

      // miConfiguracion.setString("Usuario", miUsuario.username);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  factory Datos() {
    return _singleton;
  }

  void volverAConectar() {
    setUsuario(Usuario.origin());
  }

  Datos._internal() {
    miBobina = Bobina();
    miUsuario = Usuario.origin();
  }
}
