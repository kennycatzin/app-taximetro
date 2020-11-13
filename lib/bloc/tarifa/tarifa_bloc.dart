import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tarifa_event.dart';
part 'tarifa_state.dart';

class TarifaBloc extends Bloc<TarifaEvent, TarifaState> {
  TarifaBloc() : super(TarifaState());

  @override
  Stream<TarifaState> mapEventToState(
    TarifaEvent event,
  ) async* {
    if (event is OnAsignarPrecios) {
      yield* this._onAsignarPrecios(event);
    }
  }

  Stream<TarifaState> _onAsignarPrecios(OnAsignarPrecios event) async* {
    yield state.copyWith(
        tarifaMinima: event.tarifaMinima,
        banderazo: event.banderazo,
        intervaloTiempo: event.intervaloTiempo,
        intervaloDistancia: event.intervaloDistancia,
        tarifaTiempo: event.tarifaTiempo,
        horarios: event.horarios);
  }
}
