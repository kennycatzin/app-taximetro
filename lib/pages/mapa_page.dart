import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mensaje/mensaje_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/mensaje_service.dart';
import 'package:mapa_app/services/preference_usuario.dart';
import 'package:mapa_app/services/socket_service.dart';
import 'package:mapa_app/widgets/menu_widget.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'package:mapa_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  static final String routeName = 'loading';

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> with TickerProviderStateMixin {
  bool boton = true;
  SocketService service;
  final _prefs = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    service = Provider.of<SocketService>(context, listen: false);
    Wakelock.enable();
    verificarMensajes(context);
  }

  void _escucharMensaje(dynamic payload) {
    print(payload);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
        drawer: MenuWidget(),
        body: Stack(
          children: [
            BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
                builder: (context, state) => crearMapa(state)),
            Positioned(
              top: 10,
              child: Row(
                children: [
                  SearchBar(),
                ],
              ),
            ),
            // MarcadorManual(),
            TaxistaPerfil(),
            BtnMiViaje()
          ],
        ),
        floatingActionButton: BtnsHelpers());
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion) return Center(child: Text('Ubicando...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final taximetroBloc = BlocProvider.of<TaximetroBloc>(context);
    final taxistaBloc = BlocProvider.of<UsuarioBloc>(context).state;
    if (!taximetroBloc.state.startIsPressed) {
      final nuevoMarcador = {
        "nombre": taxistaBloc.nombre,
        "lat": state.ubicacion.latitude,
        "lng": state.ubicacion.longitude,
        "id": taxistaBloc.id_usuario.toString()
      };
      // service.emit('marcador-borrar', taxistaBloc.id_usuario);
      // service.emit('marcador-nuevo', nuevoMarcador);
    }

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));

    final cameraPosition =
        new CameraPosition(target: state.ubicacion, zoom: 15);
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, _) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: mapaBloc.initMapa,
          polylines: mapaBloc.state.polylines.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
          onCameraMove: (cameraPosition) {
            // cameraPosition.target = LatLng central del mapa
            final usuarioBloc = BlocProvider.of<UsuarioBloc>(context).state;
            if (usuarioBloc.conectado) {
              // service.emit('marcador-mover', {
              //   "nombre": usuarioBloc.nombre,
              //   "lat": cameraPosition.target.latitude,
              //   "lng": cameraPosition.target.longitude,
              //   "id": usuarioBloc.id_usuario.toString()
              // });
            }
            mapaBloc.add(OnMovioMapa(cameraPosition.target));
          },
        );
      },
    );
  }

  void verificarMensajes(BuildContext context) async {
    final mensajesService = new MensajesService();
    Map info = await mensajesService.listaNuevoMensaje();
    print(info);
    if (info["ok"] == false) {
      return;
    } else {
      print("entrando a revisar");
      if (info['mensaje']['tipo'] == "CC") {
        _alertaConfirmaViaje(context, info);
      } else {
        _alertaMensajeNuevo(context, info);
      }
    }
  }

  void _alertaConfirmaViaje(BuildContext context, Map data) {
    // set up the buttons
    Widget cancelButton = ElevatedButton.icon(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // color: Colors.redAccent,
        // textColor: Colors.white,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        label: Text('Rechazar'),
        icon: Icon(Icons.cancel),
        onPressed: () => (boton == true)
            ? rechazar(context, data['mensaje']['id_mensaje'],
                data['mensaje']['id_viaje'])
            : null);

    Widget continueButton = ElevatedButton.icon(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // color: Colors.green,
      // textColor: Colors.white,
      label: Text('Aceptar'),
      icon: Icon(Icons.check_circle),
      onPressed: () => (boton == true) ? aceptar(context, data) : null,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("¿Desea aceptar viaje?")),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['mensaje']['titulo'],
                  style: new TextStyle(fontSize: 20.0)),
              Text(
                data['mensaje']['mensaje'],
              ),
            ],
          ),
        ),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _alertaMensajeNuevo(BuildContext context, Map data) {
    // set up the buttons

    Widget continueButton = ElevatedButton.icon(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // color: Colors.redAccent,
        // textColor: Colors.white,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        label: Text('Cerrar'),
        icon: Icon(Icons.cancel),
        onPressed: () => mensajeVisto(context, data["mensaje"]["id_mensaje"]));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text(data['mensaje']['titulo'])),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['mensaje']['name'],
                  style: new TextStyle(fontSize: 20.0)),
              Text(
                data['mensaje']['mensaje'],
              ),
            ],
          ),
        ),
      ),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void aceptar(BuildContext context, Map mensaje) async {
    mostrarLoading(context);
    boton = false;

    final viajeProvider = new MensajesService();
    await viajeProvider.aceptarViajeMensaje(mensaje["mensaje"]["id_viaje"]);
    final mensajeBloc = BlocProvider.of<MensajeBloc>(context);
    mensajeBloc.add(OnTapMensaje(
      mensaje["mensaje"]["id_mensaje"],
      mensaje["mensaje"]["titulo"],
      mensaje["mensaje"]["mensaje"],
      mensaje["mensaje"]["tipo"],
      mensaje["mensaje"]["name"],
      mensaje["mensaje"]["telefono"],
      mensaje["mensaje"]["correo"],
    ));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.pushNamed(context, 'detalle_mensaje');
  }

  void rechazar(BuildContext context, int id_mensaje, int id_viaje) async {
    mostrarLoading(context);
    final viajeProvider = new MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    await viajeProvider.rechazarViajeMensaje(id_viaje);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void mensajeVisto(BuildContext context, int id_mensaje) async {
    mostrarLoading(context);

    boton = false;

    final viajeProvider = new MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    print('=== entrando a dispose === ');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print('=== entrando a dispose === ');
    super.dispose();
    Wakelock.disable();
  }

  // @override
  // void deactivate() {
  //   print('=== entrando a dispose === ');
  //   service.emit('marcador-borrar', 1);
  //   super.deactivate();
  // }
}
