import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/pages/acceso_gps_page.dart';

import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/pages/cobro_page.dart';
import 'package:mapa_app/pages/cronometro_page.dart';

import 'package:mapa_app/pages/loading_page.dart';
import 'package:mapa_app/pages/login_page.dart';
import 'package:mapa_app/pages/mapa_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    config();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
        BlocProvider(create: (_) => TaximetroBloc()),
        BlocProvider(create: (_) => BusquedaBloc()),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        // home: TaxistaPerfil(),
        home: LoginPage(),
        routes: {
          'mapa': (_) => MapaPage(),
          'loading': (_) => LoadingPage(),
          'login': (_) => LoginPage(),
          'cronometro': (_) => CronometroPage(),
          'acceso_gps': (_) => AccesoGpsPage(),
          'cobro': (_) => CobroPage(),
        },
      ),
    );
  }

  void config() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}
