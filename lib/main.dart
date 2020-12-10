import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapa_app/bloc/login/provider.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/pages/acceso_gps_page.dart';

import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/pages/cobro_page.dart';
import 'package:mapa_app/pages/cronometro_page.dart';

import 'package:mapa_app/pages/loading_page.dart';
import 'package:mapa_app/pages/login_page.dart';
import 'package:mapa_app/pages/mapa_page.dart';
import 'package:mapa_app/pages/push_notificaciones_page.dart';
import 'package:mapa_app/pages/viajes_page.dart';
import 'package:mapa_app/services/preference_usuario.dart';
import 'package:mapa_app/services/push_notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final pushProvider = new PushNotificationsProvider();

    // pushProvider.initNotifictions();

    // pushProvider.mensajesStream.listen((argumento) {
    //   navigatorKey.currentState
    //       .pushReplacementNamed('notificacion', arguments: argumento);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    // config();
    return Provider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MiUbicacionBloc()),
          BlocProvider(create: (_) => MapaBloc()),
          BlocProvider(create: (_) => TaximetroBloc()),
          BlocProvider(create: (_) => BusquedaBloc()),
          BlocProvider(create: (_) => UsuarioBloc()),
          BlocProvider(create: (_) => TarifaBloc()),
        ],
        child: MaterialApp(
          title: 'Material App',
          // theme: ThemeData(
          //   brightness: Brightness.dark,
          //   primaryColor: Colors.lightBlue[800],
          //   accentColor: Colors.cyan[600],
          // ),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: 'loading',
          // home: TaxistaPerfil(),
          // home: LoginPage(),
          routes: {
            'mapa': (_) => MapaPage(),
            'loading': (_) => LoadingPage(),
            'login': (_) => LoginPage(),
            'cronometro': (_) => CronometroPage(),
            'acceso_gps': (_) => AccesoGpsPage(),
            'cobro': (_) => CobroPage(),
            'notificacion': (_) => PushNotificacionesPage(),
            'viajes': (_) => ViajesPage(),
          },
        ),
      ),
    );
  }

  void config() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}
