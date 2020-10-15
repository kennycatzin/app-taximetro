part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnActivarMarcadorManual extends BusquedaEvent {}

class OnDesActivarMarcadorManual extends BusquedaEvent {}

class OnAgregarHistorial extends BusquedaEvent {
  final SearchResult result;

  OnAgregarHistorial(this.result);
}
