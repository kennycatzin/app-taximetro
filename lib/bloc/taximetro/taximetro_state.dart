part of 'taximetro_bloc.dart';

@immutable
class TaximetroState {
  final bool startIsPressed;
  final String stoptimetoDisplay;
  final double km;
  final double pago;
  final String duracion;
  final LatLng inicio;
  final LatLng destino;

  TaximetroState(
      {this.startIsPressed = false,
      this.stoptimetoDisplay = "00:00:00",
      this.km = 0.0,
      this.pago = 5.00,
      this.duracion = "",
      this.inicio,
      this.destino});

  TaximetroState copyWith(
          {bool startIsPressed,
          String stoptimetoDisplay,
          double km,
          double pago,
          String duracion,
          LatLng inicio,
          LatLng destino}) =>
      TaximetroState(
          startIsPressed: startIsPressed ?? this.startIsPressed,
          stoptimetoDisplay: stoptimetoDisplay ?? this.stoptimetoDisplay,
          km: km ?? this.km,
          pago: pago ?? this.pago,
          duracion: duracion ?? this.duracion,
          inicio: inicio ?? this.inicio,
          destino: destino ?? this.destino);
}
