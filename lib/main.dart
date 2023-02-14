import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapa_app/bloc/mensaje/mensaje_bloc.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/pages/acceso_gps_page.dart';

import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/pages/captura_supervisor_page.dart';
import 'package:mapa_app/pages/carga_page.dart';
import 'package:mapa_app/pages/cobro_page.dart';
import 'package:mapa_app/pages/comprobante_page.dart';
import 'package:mapa_app/pages/cronometro_page.dart';
import 'package:mapa_app/pages/detalle_mensaje_page.dart';

import 'package:mapa_app/pages/loading_page.dart';
import 'package:mapa_app/pages/login_page.dart';
import 'package:mapa_app/pages/mapa_page.dart';
import 'package:mapa_app/pages/mensajes_page.dart';
import 'package:mapa_app/pages/pagado_page.dart';
import 'package:mapa_app/pages/push_notificaciones_page.dart';
import 'package:mapa_app/pages/tarjeta_page.dart';
import 'package:mapa_app/pages/viaje_manual_page.dart';
import 'package:mapa_app/pages/viajes_page.dart';
import 'package:mapa_app/services/preference_usuario.dart';
import 'package:mapa_app/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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
    return MultiProvider(
        providers: [
          BlocProvider(create: (_) => MiUbicacionBloc()),
          BlocProvider(create: (_) => MapaBloc()),
          BlocProvider(create: (_) => TaximetroBloc()),
          BlocProvider(create: (_) => BusquedaBloc()),
          BlocProvider(create: (_) => UsuarioBloc()),
          BlocProvider(create: (_) => TarifaBloc()),
          BlocProvider(create: (_) => MensajeBloc()),
          ChangeNotifierProvider(create: (_) => SocketService()),
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
          // initialRoute: 'loading',
          // home: TaxistaPerfil(),
          home: CargaPage(),
          routes: {
            'mapa': (_) => MapaPage(),
            'loading': (_) => LoadingPage(),
            'login': (_) => LoginPage(),
            'cronometro': (_) => CronometroPage(),
            'acceso_gps': (_) => AccesoGpsPage(),
            'cobro': (_) => CobroPage(),
            'notificacion': (_) => PushNotificacionesPage(),
            'viajes': (_) => ViajesPage(),
            'mensajes': (_) => MensajesPage(),
            'carga': (_) => CargaPage(),
            'detalle_mensaje': (_) => DetalleMensaje(),
            'tarjeta': (_) => TarjetaPage(),
            'pagado': (_) => PagadoPage(),
            'viaje_manual': (_) => ViajeManualPage(),
            'comprobante': (_) => Comprobante(),
            'captura_supervisor': (_) => CapturaSupervisorPage(),
          },
        ));
  }

  void config() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    print('=== entrando a dispose === ');
    super.dispose();
  }
}
