part of 'usuario_bloc.dart';

@immutable
class UsuarioState {
  final bool login;
  final String imagen;
  final String numEconomico;
  final String tituloSindical;
  final String nombre;

  UsuarioState(
      {this.login = false,
      this.imagen,
      this.numEconomico,
      this.tituloSindical,
      this.nombre});

  UsuarioState copyWith({
    bool login,
    String imagen,
    String numEconomico,
    String tituloSindical,
    String nombre,
  }) =>
      UsuarioState(
          login: login ?? this.login,
          imagen: imagen ?? this.imagen,
          numEconomico: numEconomico ?? this.numEconomico,
          tituloSindical: tituloSindical ?? this.tituloSindical,
          nombre: nombre ?? nombre);
}
