import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/pages/captura_supervisor_page.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mapa_app/helpers/helpers.dart';

import 'package:mapa_app/pages/mapa_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  static const List<DeviceOrientation> _allOrientations = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  late final Future<String> _gpsCheckFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(_allOrientations);
    _gpsCheckFuture = checkGpsYLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final gpsActivo = await Geolocator.isLocationServiceEnabled();
      if (!mounted) {
        return;
      }

      if (gpsActivo) {
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, MapaPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _gpsCheckFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data ?? ''));
          } else {
            print('==== mis conectadooooooo =====');
            print(snapshot.data);
            return Center(child: CircularProgressIndicator(strokeWidth: 2));
          }
        },
      ),
    );
  }

  Future<String> checkGpsYLocation() async {
    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    // GPS está activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (!mounted) {
      return '';
    }

    final usuarioState = BlocProvider.of<UsuarioBloc>(context).state;

    if (usuarioState.tipo_usuario == "SUPERVISOR") {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, CapturaSupervisorPage()));
      return '';
    }
    if (permisoGPS && gpsActivo) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, MapaPage()));
      return '';
    } else if (!permisoGPS) {
      Navigator.pushNamed(context, 'acceso_gps');
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Active el GPS';
    }
  }
}
