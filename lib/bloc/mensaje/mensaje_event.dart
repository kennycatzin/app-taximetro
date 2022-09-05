part of 'mensaje_bloc.dart';

@immutable
abstract class MensajeEvent {}

class OnTapMensaje extends MensajeEvent {
  final int id_mensaje;
  final String titulo;
  final String mensaje;
  final String tipo;
  final String name;
  final String telefono;
  final String correo;
  OnTapMensaje(this.id_mensaje, this.titulo, this.mensaje, this.tipo, this.name,
      this.telefono, this.correo);
}

class OnTapSendComprobante extends MensajeEvent {
  final String viajeID;
  OnTapSendComprobante(this.viajeID);
}
