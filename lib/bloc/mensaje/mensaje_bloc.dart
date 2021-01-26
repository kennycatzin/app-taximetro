import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mensaje_event.dart';
part 'mensaje_state.dart';

class MensajeBloc extends Bloc<MensajeEvent, MensajeState> {
  MensajeBloc() : super(MensajeState());

  @override
  Stream<MensajeState> mapEventToState(
    MensajeEvent event,
  ) async* {
    if (event is OnTapMensaje) {
      yield* this._onTapMensaje(event);
    }
  }

  Stream<MensajeState> _onTapMensaje(OnTapMensaje event) async* {
    yield state.copyWith(
        id_mensaje: event.id_mensaje,
        tipo: event.tipo,
        titulo: event.titulo,
        mensaje: event.mensaje,
        name: event.name);
  }
}
