import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:mapa_app/helpers/helpers.dart';
import 'package:meta/meta.dart';

import 'package:mapa_app/themes/uber_map_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());

  // Controlador del mapa
  GoogleMapController _mapController;

  // Polylines
  Polyline _miRuta = new Polyline(
      polylineId: PolylineId('mi_ruta'), width: 4, color: Colors.transparent);

  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId('mi_ruta_destino'),
      width: 4,
      color: Colors.redAccent);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNuevaUbicacion) {
      yield* this._onNuevaUbicacion(event);
    } else if (event is OnMarcarRecorrido) {
      yield* this._onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      print(event.centroMapa);
      yield* this._onMovioMapa(event);
    } else if (event is OnCrearRutaInicioDestino) {
      yield* _onCrearRutaInicioDestino(event);
    } else if (event is OnCrearMarcadorInicio) {
      yield* this._onCrearMarcadorInicio(event);
    } else if (event is OnCrearMarcadorFinal) {
      yield* this._onCrearMarcadorFinal(event);
    } else if (event is OnQuitarPoliline) {
      yield* this._onQuitarPoliline(event);
    } else if (event is OnQuitarMarcadores) {
      yield* this._onQuitarMarcadores(event);
    } else if (event is OnMapaCrea) {
      yield state.copyWith(mapaListo: false);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }

    final points = [...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.redAccent);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolylines);
  }

  Stream<MapaState> _onQuitarPoliline(OnQuitarPoliline event) async* {
    this._miRuta = new Polyline(
        polylineId: PolylineId('mi_ruta'), width: 4, color: Colors.transparent);
    final currentPolylines = new Map<String, Polyline>();
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event) async* {
    this._miRutaDestino =
        this._miRutaDestino.copyWith(pointsParam: event.rutaCoordenadas);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    // Marcadores
    // final iconInicio = await getAssetImageMarker();
    // final iconDestino = await getNetworkImageMarker();

    final iconInicio =
        await getMarkerInicioIcon(event.duracion.toInt(), event.distancia);
    final iconDestino =
        await getMarkerDestinoIcon(event.nombreDestino, event.distancia);
    final markerInicio = new Marker(
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('inicio'),
        position: event.rutaCoordenadas[0],
        icon: iconInicio,
        infoWindow: InfoWindow(
            title: 'Mi ubicación',
            snippet: 'Duracion: ${(event.duracion / 60).floor()} min.',
            anchor: Offset(0.5, 0.0),
            onTap: () {
              print('Info window tap');
            }));

    // marcador final
    double kilometros = event.distancia / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;
    final markerFinal = new Marker(
        anchor: Offset(0.1, 0.90),
        markerId: MarkerId('final'),
        position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1],
        icon: iconDestino,
        infoWindow: InfoWindow(
            title: event.nombreDestino,
            snippet: 'Distancia: ${kilometros} km',
            onTap: () {
              print('Info window tap');
            }));

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['final'] = markerFinal;

    Future.delayed(Duration(milliseconds: 300)).then((value) => {
          //_mapController.showMarkerInfoWindow(MarkerId('final'))
        });

    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }

  Stream<MapaState> _onCrearMarcadorInicio(OnCrearMarcadorInicio event) async* {
    // Marcadores
    final iconInicio = await getNetworkImageMarker();
    final markerInicio = new Marker(
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('inicio'),
        position: event.ubicacion,
        icon: iconInicio,
        infoWindow: InfoWindow(
            title: 'Mi ubicación',
            snippet: 'Duracion: 0 min.',
            anchor: Offset(0.0, 0.0),
            onTap: () {
              print('Info window tap');
            }));

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    Future.delayed(Duration(milliseconds: 300)).then((value) => {
          //_mapController.showMarkerInfoWindow(MarkerId('final'))
        });
    yield state.copyWith(markers: newMarkers);
  }

  Stream<MapaState> _onQuitarMarcadores(OnQuitarMarcadores event) async* {
    // Marcadores
    final marcador = new Marker(markerId: MarkerId('inicio'));
    final marcadorFinal = new Marker(markerId: MarkerId('final'));

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = marcador;
    newMarkers['final'] = marcadorFinal;

    yield state.copyWith(markers: newMarkers);
  }

  Stream<MapaState> _onCrearMarcadorFinal(OnCrearMarcadorFinal event) async* {
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    // Marcadores
    final iconInicio = await getNetworkImageMarker();
    final markerInicio = new Marker(
        anchor: Offset(0.0, 1.0),
        markerId: MarkerId('inicio'),
        position: event.ubicacion,
        icon: iconInicio,
        infoWindow: InfoWindow(
            title: 'Mi ubicación',
            snippet: 'Duracion: 0 min.',
            anchor: Offset(0.0, 0.0),
            onTap: () {
              print('Info window tap');
            }));

    final newMarkers = {...state.markers};
    newMarkers['final'] = markerInicio;
    Future.delayed(Duration(milliseconds: 300)).then((value) => {
          //_mapController.showMarkerInfoWindow(MarkerId('final'))
        });
    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }

  Stream<MapaState> _onMovioMapa(OnMovioMapa event) async* {
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    // Marcadores()
    final iconInicio = await getAssetImageMarker();
    final markerInicio = new Marker(
        anchor: Offset(0.5, 1.0),
        markerId: MarkerId('final'),
        position: event.centroMapa,
        icon: iconInicio,
        infoWindow: InfoWindow(
            title: 'Mi ubicación',
            snippet: 'Duracion: 0 min.',
            anchor: Offset(0.0, 0.0),
            onTap: () {
              print('Info window tap');
            }));

    final newMarkers = {...state.markers};
    newMarkers['final'] = markerInicio;
    Future.delayed(Duration(milliseconds: 300)).then((value) => {
          //_mapController.showMarkerInfoWindow(MarkerId('final'))
        });
    yield state.copyWith(
        ubicacionCentral: event.centroMapa, markers: newMarkers);
  }
}
