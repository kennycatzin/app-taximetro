part of 'mensaje_bloc.dart';

@immutable
class MensajeState {
  final int id_mensaje;
  final String titulo;
  final String mensaje;
  final String tipo;
  final String name;
  final String telefono;
  final String correo;
  final String viajeID;

  MensajeState({
    this.id_mensaje,
    this.titulo,
    this.mensaje,
    this.tipo,
    this.name,
    this.telefono,
    this.correo,
    this.viajeID,
  });

  MensajeState copyWith(
          {int id_mensaje,
          String titulo,
          String mensaje,
          String tipo,
          String name,
          String telefono,
          String correo,
          String viajeID}) =>
      MensajeState(
          id_mensaje: id_mensaje ?? this.id_mensaje,
          titulo: titulo ?? this.titulo,
          mensaje: mensaje ?? this.mensaje,
          tipo: tipo ?? this.tipo,
          name: name ?? this.name,
          telefono: telefono ?? this.telefono,
          correo: correo ?? this.correo,
          viajeID: viajeID ?? this.viajeID);
}
