part of 'usuario_bloc.dart';

@immutable
class UsuarioState {
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

  UsuarioState(
      {this.conectado = false,
      this.id_usuario,
      this.login = false,
      this.imagen,
      this.centro_imagen,
      this.numEconomico,
      this.tituloSindical,
      this.nombre,
      this.id_status,
      this.centro_trabajo,
      this.id_centro_trabajo});

  UsuarioState copyWith(
          {bool conectado,
          int id_usuario,
          bool login,
          String imagen,
          String centro_imagen,
          String numEconomico,
          String tituloSindical,
          String nombre,
          int id_status,
          String centro_trabajo,
          int id_centro_trabajo}) =>
      UsuarioState(
          conectado: conectado ?? this.conectado,
          id_usuario: id_usuario ?? this.id_usuario,
          login: login ?? this.login,
          imagen: imagen ?? this.imagen,
          centro_imagen: centro_imagen ?? this.centro_imagen,
          numEconomico: numEconomico ?? this.numEconomico,
          tituloSindical: tituloSindical ?? this.tituloSindical,
          nombre: nombre ?? this.nombre,
          id_status: id_status ?? this.id_status,
          centro_trabajo: centro_trabajo ?? this.centro_trabajo,
          id_centro_trabajo: id_centro_trabajo ?? this.id_centro_trabajo);
}
