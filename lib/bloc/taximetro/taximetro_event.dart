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
  final bool estado;

  OnCorreTaximetro(this.km, this.duracion, this.inicio, this.estado);
}

class OnIniciarValores extends TaximetroEvent {}

class OnHoraInicio extends TaximetroEvent {
  final String hora;
  OnHoraInicio(this.hora);
}

class OnHoraFinal extends TaximetroEvent {
  final String hora;
  OnHoraFinal(this.hora);
}
