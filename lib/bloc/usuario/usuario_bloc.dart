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
    } else if (event is OnConectado) {
      yield state.copyWith(conectado: event.conectado);
    }
  }

  Stream<UsuarioState> _onLogin(OnLogin event) async* {
    // swatch.start();
    // startTimer();
    yield state.copyWith(
        conectado: event.conectado,
        id_usuario: event.id_usuario,
        login: event.login,
        imagen: event.imagen,
        centro_imagen: event.centro_imagen,
        nombre: event.nombre,
        tituloSindical: event.tituloSindical,
        numEconomico: event.numEconomico,
        id_status: event.id_status,
        id_centro_trabajo: event.id_centro_trabajo,
        centro_trabajo: event.centro_trabajo);
  }
}
