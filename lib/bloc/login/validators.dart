import 'dart:async';

class Validators {
  final validarEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (usuario, sink) {
    if (usuario.length >= 3) {
      sink.add(usuario);
    } else {
      sink.addError('Más de 3 caracteres');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Más de 6 caracteres');
    }
  });
}
