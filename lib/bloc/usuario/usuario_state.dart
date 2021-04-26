part of 'usuario_bloc.dart';

@immutable
class UsuarioState {
  final bool login;
  final String imagen;
  final String numEconomico;
  final String tituloSindical;
  final String nombre;
  final int id_status;

  UsuarioState(
      {this.login = false,
      this.imagen,
      this.numEconomico,
      this.tituloSindical,
      this.nombre,
      this.id_status});

  UsuarioState copyWith(
          {bool login,
          String imagen,
          String numEconomico,
          String tituloSindical,
          String nombre,
          int id_status}) =>
      UsuarioState(
          login: login ?? this.login,
          imagen: imagen ?? this.imagen,
          numEconomico: numEconomico ?? this.numEconomico,
          tituloSindical: tituloSindical ?? this.tituloSindical,
          nombre: nombre ?? nombre,
          id_status: id_status ?? id_status);
}
