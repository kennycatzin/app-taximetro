part of 'tarifa_bloc.dart';

@immutable
abstract class TarifaEvent {}

class OnAsignarPrecios extends TarifaEvent {
  final double tarifaMinima;
  final double banderazo;
  final int intervaloTiempo;
  final int intervaloDistancia;
  final double tarifaTiempo;
  final List<dynamic> horarios;

  OnAsignarPrecios(this.tarifaMinima, this.banderazo, this.intervaloTiempo,
      this.intervaloDistancia, this.tarifaTiempo, this.horarios);
}
