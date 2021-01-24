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
  final String horaInicio;
  final String horaFinal;
  final int metaTiempo;
  final bool cobraTiempo;
  final double metaCobro;
  final double metaDistancia;
  final double tiempoCobroMeta;
  final double pagoTiempo;

  TaximetroState(
      {this.startIsPressed = false,
      this.stoptimetoDisplay = "00:00:00",
      this.km = 0.0,
      this.pago = 0.00,
      this.duracion = "",
      this.inicio,
      this.destino,
      this.horaInicio,
      this.horaFinal,
      this.metaTiempo = -10,
      this.cobraTiempo = false,
      this.metaCobro = 0.0,
      this.metaDistancia = 0.0,
      this.tiempoCobroMeta = 0.0,
      this.pagoTiempo});

  TaximetroState copyWith(
          {bool startIsPressed,
          String stoptimetoDisplay,
          double km,
          double pago,
          String duracion,
          LatLng inicio,
          LatLng destino,
          String horaInicio,
          String horaFinal,
          int metaTiempo,
          bool cobraTiempo,
          double metaCobro,
          double metaDistancia,
          double tiempoCobroMeta,
          double pagoTiempo}) =>
      TaximetroState(
          startIsPressed: startIsPressed ?? this.startIsPressed,
          stoptimetoDisplay: stoptimetoDisplay ?? this.stoptimetoDisplay,
          km: km ?? this.km,
          pago: pago ?? this.pago,
          duracion: duracion ?? this.duracion,
          inicio: inicio ?? this.inicio,
          destino: destino ?? this.destino,
          horaInicio: horaInicio ?? this.horaInicio,
          horaFinal: horaFinal ?? this.horaFinal,
          metaTiempo: metaTiempo ?? this.metaTiempo,
          cobraTiempo: cobraTiempo ?? this.cobraTiempo,
          metaCobro: metaCobro ?? this.metaCobro,
          metaDistancia: metaDistancia ?? this.metaDistancia,
          tiempoCobroMeta: tiempoCobroMeta ?? this.tiempoCobroMeta,
          pagoTiempo: pagoTiempo ?? this.pagoTiempo);
}
