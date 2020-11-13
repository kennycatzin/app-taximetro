part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioEvent {}

class OnLogin extends UsuarioEvent {
  final bool login;
  final String imagen;
  final String numEconomico;
  final String tituloSindical;
  final String nombre;

  OnLogin(this.login, this.imagen, this.numEconomico, this.tituloSindical,
      this.nombre);
}
