part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;

  final LatLng ubicacionCentral;
  final int tipo;

  // Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapaState(
      {this.mapaListo = false,
      this.dibujarRecorrido = false,
      this.seguirUbicacion = false,
      this.ubicacionCentral,
      this.tipo,
      Map<String, Polyline> polylines,
      Map<String, Marker> markers})
      : this.polylines = polylines ?? new Map(),
        this.markers = markers ?? new Map();

  MapaState copyWith(
          {bool mapaListo,
          bool dibujarRecorrido,
          bool seguirUbicacion,
          LatLng ubicacionCentral,
          int tipo,
          Map<String, Polyline> polylines,
          Map<String, Marker> markers}) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        tipo: tipo ?? this.tipo,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
      );
}
