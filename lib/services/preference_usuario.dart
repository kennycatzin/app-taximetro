import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del Genero
  int get usuarioID {
    return _prefs.getInt('usuarioID') ?? 0;
  }

  set usuarioID(int value) {
    _prefs.setInt('usuarioID', value);
  }

  // // GET y SET del _colorSecundario
  // get colorSecundario {
  //   return _prefs.getBool('colorSecundario') ?? false;
  // }

  // set colorSecundario(bool value) {
  //   _prefs.setBool('colorSecundario', value);
  // }

  // GET y SET del token
  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  // GET y SET de la última página
  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  String get tokenPushNotify {
    return _prefs.getString('tokenPushNotify') ?? '';
  }

  set tokenPushNotify(String value) {
    _prefs.setString('tokenPushNotify', value);
  }
}
