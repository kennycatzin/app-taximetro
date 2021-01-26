part of 'mensaje_bloc.dart';

@immutable
abstract class MensajeEvent {}

class OnTapMensaje extends MensajeEvent {
  final int id_mensaje;
  final String titulo;
  final String mensaje;
  final int tipo;
  final String name;

  OnTapMensaje(
      this.id_mensaje, this.titulo, this.mensaje, this.tipo, this.name);
}
