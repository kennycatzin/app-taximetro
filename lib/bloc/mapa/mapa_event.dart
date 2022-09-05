part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnMapaCrea extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnTipoMapa extends MapaEvent {
  final int tipo;
  OnTipoMapa(this.tipo);
}

class OnCrearRutaInicioDestino extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duracion;
  final String nombreDestino;

  OnCrearRutaInicioDestino(
      this.rutaCoordenadas, this.distancia, this.duracion, this.nombreDestino);
}

class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;
  OnMovioMapa(this.centroMapa);
}

class OnNuevaUbicacion extends MapaEvent {
  final LatLng ubicacion;
  OnNuevaUbicacion(this.ubicacion);
}

class OnCrearMarcadorInicio extends MapaEvent {
  final LatLng ubicacion;
  OnCrearMarcadorInicio(this.ubicacion);
}

class OnCrearMarcadorFinal extends MapaEvent {
  final LatLng ubicacion;
  OnCrearMarcadorFinal(this.ubicacion);
}

class OnQuitarPoliline extends MapaEvent {}

class OnQuitarMarcadores extends MapaEvent {}
