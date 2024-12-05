import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

abstract class Dependencia {
  static void inicializar() {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    GetIt.instance.registerSingleton<FlutterSecureStorage>(secureStorage);

    //String sUrl = "http://10.0.2.2:8091/Service1.svc";

    //SharedPreferences miConfiguracion = await SharedPreferences.getInstance();

    // sUrl = miConfiguracion.getString("URL");

    //final Dio _dio = Dio(BaseOptions(baseUrl: sUrl));

    //Http http = Http(
    // dio: _dio,
    // logsEnabled: true,
    //);

    //final BBDD miBBDD = BBDD(http);

    //final AuthenticationCliente authenticationCliente = AuthenticationCliente(_secureStorage,authenticationAPI);
    //final UsuarioAPI usuarioAPI = UsuarioAPI(http, authenticationCliente);

    //GetIt.instance.registerSingleton<BBDD>(miBBDD);

    //GetIt.instance.registerSingleton<AuthenticationCliente>(authenticationCliente);
    //GetIt.instance.registerSingleton<UsuarioAPI>(usuarioAPI);
  }
}
