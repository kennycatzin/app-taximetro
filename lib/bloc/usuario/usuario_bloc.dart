import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'usuario_event.dart';
part 'usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  UsuarioBloc() : super(UsuarioState());

  @override
  Stream<UsuarioState> mapEventToState(UsuarioEvent event) async* {
    if (event is OnLogin) {
      yield* this._onLogin(event);
    }
  }

  Stream<UsuarioState> _onLogin(OnLogin event) async* {
    // swatch.start();
    // startTimer();
    yield state.copyWith(
        login: event.login,
        imagen: event.imagen,
        nombre: event.nombre,
        tituloSindical: event.tituloSindical,
        numEconomico: event.numEconomico,
        id_status: event.id_status);
  }
}
