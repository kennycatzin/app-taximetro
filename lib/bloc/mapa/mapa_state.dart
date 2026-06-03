part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng? ubicacionCentral;
  final int? tipo;
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = false,
    this.ubicacionCentral,
    this.tipo,
    this.polylines = const {},
    this.markers = const {},
  });

  MapaState copyWith({
    bool? mapaListo,
    bool? dibujarRecorrido,
    bool? seguirUbicacion,
    LatLng? ubicacionCentral,
    int? tipo,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        tipo: tipo ?? this.tipo,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );
}
