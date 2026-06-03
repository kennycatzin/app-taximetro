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
import 'package:mapa_app/services/socket_service.dart';
import 'package:mapa_app/widgets/menu_widget.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:mapa_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  static final String routeName = 'loading';

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> with TickerProviderStateMixin {
  bool boton = true;
  late SocketService service;

  @override
  void initState() {
    super.initState();
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    service = Provider.of<SocketService>(context, listen: false);
    WakelockPlus.enable();
    verificarMensajes(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(),
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
              builder: (context, state) => crearMapa(state)),
          Positioned(
            top: 10,
            child: DestinationSearchBar(),
          ),
          MarcadorManual(),
          TaxistaPerfil(),
          BtnMiViaje(),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 300, left: 170),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [BtnUbicacion(), BtnSeguirUbicacion(), BtnMiRuta()],
          ),
        ),
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion) return Center(child: Text('Ubicando...'));
    final ubicacion = state.ubicacion;
    if (ubicacion == null) return Center(child: Text('Ubicando...'));

    final mapaBloc = context.read<MapaBloc>();
    final taximetroBloc = context.read<TaximetroBloc>();
    if (!taximetroBloc.state.startIsPressed) {
      // service.emit('marcador-borrar', taxistaBloc.id_usuario);
      // service.emit('marcador-nuevo', nuevoMarcador);
    }

    mapaBloc.add(OnNuevaUbicacion(ubicacion));

    final cameraPosition = CameraPosition(target: ubicacion, zoom: 15);
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
            final usuarioBloc = context.read<UsuarioBloc>().state;
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
    final mensajesService = MensajesService();
    Map info = await mensajesService.listaNuevoMensaje();
    if (info["ok"] == false) {
      return;
    }

    if (info['mensaje']['tipo'] == "CC") {
      _alertaConfirmaViaje(context, info);
    } else {
      _alertaMensajeNuevo(context, info);
    }
  }

  void _alertaConfirmaViaje(BuildContext context, Map data) {
    Widget cancelButton = ElevatedButton.icon(
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
      label: Text('Aceptar'),
      icon: Icon(Icons.check_circle),
      onPressed: () => (boton == true) ? aceptar(context, data) : null,
    );

    AlertDialog alert = AlertDialog(
      title: Center(child: Text("¿Desea aceptar viaje?")),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['mensaje']['titulo'],
                  style: TextStyle(fontSize: 20.0)),
              Text(data['mensaje']['mensaje']),
            ],
          ),
        ),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _alertaMensajeNuevo(BuildContext context, Map data) {
    Widget continueButton = ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        label: Text('Cerrar'),
        icon: Icon(Icons.cancel),
        onPressed: () => mensajeVisto(context, data["mensaje"]["id_mensaje"]));

    AlertDialog alert = AlertDialog(
      title: Center(child: Text(data['mensaje']['titulo'])),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['mensaje']['name'],
                  style: TextStyle(fontSize: 20.0)),
              Text(data['mensaje']['mensaje']),
            ],
          ),
        ),
      ),
      actions: [continueButton],
    );

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

    final viajeProvider = MensajesService();
    await viajeProvider.aceptarViajeMensaje(mensaje["mensaje"]["id_viaje"]);
    final mensajeBloc = context.read<MensajeBloc>();
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
    final viajeProvider = MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    await viajeProvider.rechazarViajeMensaje(id_viaje);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void mensajeVisto(BuildContext context, int id_mensaje) async {
    mostrarLoading(context);
    boton = false;

    final viajeProvider = MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WakelockPlus.disable();
    super.dispose();
  }
}
