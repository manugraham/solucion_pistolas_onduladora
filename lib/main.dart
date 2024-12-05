import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:solucion_pistolas_onduladora/src/data/helpers/Dependencias.dart';
import 'package:solucion_pistolas_onduladora/src/rutas/rutas.dart';

void main() {
  Dependencia.inicializar();
  runApp(RestartWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //CON ESTO BLOQUEAMOS LA ORIENTACION DE LA APP, PARA QUE SOLO SE VEA DE FORMA VERTICAL

    /* SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);*/

    return MaterialApp(
      title: 'App Bobinas',
      theme: ThemeData(fontFamily: 'Monserrat'),
      debugShowCheckedModeBanner: false, //quita el banner de debug
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: [
        //const Locale('en', 'US'), //aqui ponemos los lenguajes que podemos utilizar en la aplicacion
        const Locale('es', 'ES')
      ],
      initialRoute: "/",
      routes: dameRutasAplicacion(),
      onGenerateRoute: (RouteSettings settings) {
        //sino encuentra la ruta manda a una que yo le ponga por defecto.
        print('Ruta erronea');
        return null;
        // return MaterialPageRoute(builder:(BuildContext context) => AlertPage());
      },
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
