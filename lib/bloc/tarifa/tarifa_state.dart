part of 'tarifa_bloc.dart';

@immutable
class TarifaState {
  final double tarifaMinima;
  final double tarifaMinimaCentral;
  final double tarifaMinimaOriginal;
  final double banderazo;
  final int intervaloTiempo;
  final int intervaloDistancia;
  final double tarifaTiempo;
  final List<dynamic> horarios;

  TarifaState(
      {this.tarifaMinima,
      this.tarifaMinimaCentral,
      this.tarifaMinimaOriginal,
      this.banderazo,
      this.intervaloTiempo,
      this.intervaloDistancia,
      this.tarifaTiempo,
      this.horarios});

  TarifaState copyWith(
          {double tarifaMinima,
          double tarifaMinimaCentral,
          double tarifaMinimaOriginal,
          double banderazo,
          int intervaloTiempo,
          int intervaloDistancia,
          double tarifaTiempo,
          List<dynamic> horarios}) =>
      TarifaState(
          tarifaMinima: tarifaMinima ?? this.tarifaMinima,
          tarifaMinimaCentral: tarifaMinimaCentral ?? this.tarifaMinimaCentral,
          tarifaMinimaOriginal:
              tarifaMinimaOriginal ?? this.tarifaMinimaOriginal,
          banderazo: banderazo ?? this.banderazo,
          intervaloTiempo: intervaloTiempo ?? this.intervaloTiempo,
          intervaloDistancia: intervaloDistancia ?? this.intervaloDistancia,
          tarifaTiempo: tarifaTiempo ?? this.tarifaTiempo,
          horarios: horarios ?? this.horarios);
}
