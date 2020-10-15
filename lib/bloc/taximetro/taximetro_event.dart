part of 'taximetro_bloc.dart';

@immutable
abstract class TaximetroEvent {}

class OnStartIsPressed extends TaximetroEvent {
  final LatLng centroMapa;
  OnStartIsPressed(this.centroMapa);
}

class OnCotizarPrecio extends TaximetroEvent {
  final String km;
  final String duracion;

  OnCotizarPrecio(this.km, this.duracion);
}

class OnCorreTaximetro extends TaximetroEvent {
  final double km;
  final double duracion;
  final LatLng inicio;

  OnCorreTaximetro(this.km, this.duracion, this.inicio);
}
