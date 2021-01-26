part of 'mensaje_bloc.dart';

@immutable
class MensajeState {
  final int id_mensaje;
  final String titulo;
  final String mensaje;
  final int tipo;
  final String name;

  MensajeState({
    this.id_mensaje,
    this.titulo,
    this.mensaje,
    this.tipo,
    this.name,
  });

  MensajeState copyWith({
    int id_mensaje,
    String titulo,
    String mensaje,
    int tipo,
    String name,
  }) =>
      MensajeState(
        id_mensaje: id_mensaje ?? this.id_mensaje,
        titulo: titulo ?? this.titulo,
        mensaje: mensaje ?? this.mensaje,
        tipo: tipo ?? this.tipo,
        name: name ?? this.name,
      );
}
