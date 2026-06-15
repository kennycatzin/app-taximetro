import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapa_app/bloc/busqueda/busqueda_bloc.dart';
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
  static const List<DeviceOrientation> _allOrientations = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];
  static const LatLng _defaultMapCenter = LatLng(21.011144, -89.613515);

  bool boton = true;
  bool _showQuickActions = false;
  bool _didCenterRequestedLocation = false;
  late SocketService service;
  late MiUbicacionBloc _miUbicacionBloc;

  @override
  void initState() {
    super.initState();
    _miUbicacionBloc = context.read<MiUbicacionBloc>();
    _miUbicacionBloc.iniciarSeguimiento();
    SystemChrome.setPreferredOrientations(_allOrientations);
    service = Provider.of<SocketService>(context, listen: false);
    WakelockPlus.enable();
    verificarMensajes();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final seleccionManual =
            context.select((BusquedaBloc bloc) => bloc.state.seleccionManual);
        final viajeIniciado =
            context.select((TaximetroBloc bloc) => bloc.state.startIsPressed);
        final ocultarOverlays = seleccionManual && !viajeIniciado;
        final panelBottom = isLandscape ? 18.0 : 16.0;

        return Scaffold(
          drawer: MenuWidget(),
          body: Stack(
            children: [
              Positioned.fill(
                child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
                    builder: (context, state) => crearMapa(state)),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isLandscape
                            ? [
                                Colors.black.withOpacity(0.10),
                                Colors.transparent,
                                Colors.black.withOpacity(0.08),
                              ]
                            : [
                                Colors.black.withOpacity(0.12),
                                Colors.transparent,
                                Colors.black.withOpacity(0.14),
                              ],
                      ),
                    ),
                  ),
                ),
              ),
              if (!ocultarOverlays)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: panelBottom,
                  child: SafeArea(
                    top: false,
                    child: Align(
                      alignment: isLandscape
                          ? Alignment.bottomRight
                          : Alignment.bottomCenter,
                      child: TaxistaPerfil(isLandscape: isLandscape),
                    ),
                  ),
                ),
              Positioned.fill(
                child: MarcadorManual(isLandscape: isLandscape),
              ),
              if (!ocultarOverlays)
                Positioned(
                  top: 0,
                  left: 16,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.white.withOpacity(0.96),
                          elevation: 12,
                          borderRadius: BorderRadius.circular(22),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              setState(() {
                                _showQuickActions = !_showQuickActions;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Icon(
                                _showQuickActions
                                    ? Icons.close_rounded
                                    : Icons.menu_rounded,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axisAlignment: -1,
                                child: child,
                              ),
                            );
                          },
                          child: !_showQuickActions
                              ? SizedBox.shrink(
                                  key: ValueKey('quick-actions-closed'))
                              : Material(
                                  key: ValueKey('quick-actions-open'),
                                  color: Colors.white.withOpacity(0.94),
                                  elevation: 14,
                                  borderRadius: BorderRadius.circular(32),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BtnUbicacion(),
                                        SizedBox(height: 12),
                                        BtnSeguirUbicacion(),
                                        SizedBox(height: 12),
                                        BtnMiRuta(),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    final hasLocation = state.existeUbicacion && state.ubicacion != null;
    final ubicacion = hasLocation ? state.ubicacion! : _defaultMapCenter;

    final mapaBloc = context.read<MapaBloc>();
    final taximetroBloc = context.read<TaximetroBloc>();
    if (!taximetroBloc.state.startIsPressed) {
      // service.emit('marcador-borrar', taxistaBloc.id_usuario);
      // service.emit('marcador-nuevo', nuevoMarcador);
    }

    if (hasLocation) {
      mapaBloc.add(OnNuevaUbicacion(ubicacion));
    }

    final cameraPosition = CameraPosition(
      target: ubicacion,
      zoom: hasLocation ? 15 : 16,
    );
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, mapaState) {
        _centerMapOnRequestedLocationOnce(mapaBloc, mapaState);

        return GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          buildingsEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: true,
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

  void _centerMapOnRequestedLocationOnce(
    MapaBloc mapaBloc,
    MapaState mapaState,
  ) {
    if (_didCenterRequestedLocation || !mapaState.mapaListo) {
      return;
    }

    _didCenterRequestedLocation = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      mapaBloc.moverCamara(_defaultMapCenter);
    });
  }

  void verificarMensajes() async {
    final mensajesService = MensajesService();
    Map info = await mensajesService.listaNuevoMensaje();
    if (!mounted) {
      return;
    }

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
              Text(data['mensaje']['titulo'], style: TextStyle(fontSize: 20.0)),
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
              Text(data['mensaje']['name'], style: TextStyle(fontSize: 20.0)),
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
    if (!mounted) {
      return;
    }

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
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void mensajeVisto(BuildContext context, int id_mensaje) async {
    mostrarLoading(context);
    boton = false;

    final viajeProvider = MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _miUbicacionBloc.cancelarSeguimiento();
    SystemChrome.setPreferredOrientations(_allOrientations);
    WakelockPlus.disable();
    super.dispose();
  }
}
