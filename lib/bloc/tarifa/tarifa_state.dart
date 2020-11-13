part of 'tarifa_bloc.dart';

@immutable
class TarifaState {
  final double tarifaMinima;
  final double banderazo;
  final int intervaloTiempo;
  final int intervaloDistancia;
  final double tarifaTiempo;
  final List<dynamic> horarios;

  TarifaState(
      {this.tarifaMinima,
      this.banderazo,
      this.intervaloTiempo,
      this.intervaloDistancia,
      this.tarifaTiempo,
      this.horarios});

  TarifaState copyWith(
          {double tarifaMinima,
          double banderazo,
          int intervaloTiempo,
          int intervaloDistancia,
          double tarifaTiempo,
          List<dynamic> horarios}) =>
      TarifaState(
          tarifaMinima: tarifaMinima ?? this.tarifaMinima,
          banderazo: banderazo ?? this.banderazo,
          intervaloTiempo: intervaloTiempo ?? this.intervaloTiempo,
          intervaloDistancia: intervaloDistancia ?? this.intervaloDistancia,
          tarifaTiempo: tarifaTiempo ?? this.tarifaTiempo,
          horarios: horarios ?? this.horarios);
}
