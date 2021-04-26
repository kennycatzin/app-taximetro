part of 'taximetro_bloc.dart';

@immutable
abstract class TaximetroEvent {}

class OnStartIsPressed extends TaximetroEvent {
  final LatLng centroMapa;
  final double banderazo;
  OnStartIsPressed(this.centroMapa, this.banderazo);
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
  final double tarifa;
  final bool enEspera;
  final double tarifaMinima;
  final double tarifaTiempo;
  final double banderazo;

  OnCorreTaximetro(
      this.km,
      this.duracion,
      this.inicio,
      this.estado,
      this.tarifa,
      this.enEspera,
      this.tarifaMinima,
      this.tarifaTiempo,
      this.banderazo);
}

class OnEspera extends TaximetroEvent {
  final double tarifaTiempo;
  final int intervalo;
  final int prograInter;
  final bool finaliza;
  final double tarifaMinima;
  final double banderazo;

  OnEspera(this.tarifaTiempo, this.intervalo, this.prograInter, this.finaliza,
      this.tarifaMinima, this.banderazo);
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

class OnViajeManual extends TaximetroEvent {
  final double km;
  final double pago;
  final double pagoTiempo;
  final String horaInicio;
  final String horaFinal;

  OnViajeManual(
      this.km, this.pago, this.pagoTiempo, this.horaInicio, this.horaFinal);
}
