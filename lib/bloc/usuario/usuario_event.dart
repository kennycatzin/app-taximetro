part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioEvent {}

class OnLogin extends UsuarioEvent {
  final bool conectado;
  final int id_usuario;
  final bool login;
  final String imagen;
  final String centro_imagen;
  final String numEconomico;
  final String tituloSindical;
  final String nombre;
  final int id_status;
  final String centro_trabajo;
  final int id_centro_trabajo;

  OnLogin(
      this.conectado,
      this.id_usuario,
      this.login,
      this.imagen,
      this.centro_imagen,
      this.numEconomico,
      this.tituloSindical,
      this.nombre,
      this.id_status,
      this.centro_trabajo,
      this.id_centro_trabajo);
}

class OnConectado extends UsuarioEvent {
  final bool conectado;

  OnConectado(this.conectado);
}
