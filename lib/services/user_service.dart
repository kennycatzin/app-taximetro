import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapa_app/services/preference_usuario.dart';

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyDZCaIJhlOyJxgksAQ2doZ-GY-mie7t0Y8';
  final _prefs = new PreferenciasUsuario();
  final _local = 'http://192.168.1.93:8888/mapas-api';
  final _prod = 'http://mapas-api.herokuapp.com';
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {'email': email, 'password': password};

    final resp = await http.post('$_prod/public/api/login', body: authData);

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('token')) {
      // TODO salvar el token en el sstorage
      _prefs.token = decodedResp['token'];
      _prefs.usuarioID = decodedResp['id'];

      return {'ok': 'true', 'token': decodedResp['token']};
    } else {
      if (decodedResp['ok'] == "pago") {
        return {
          'ok': 'pago',
          'mensaje': "Favor de pasar a la secretaria para realizar el pago",
          'data': decodedResp
        };
      }
      return {'ok': 'false', 'mensaje': decodedResp['mensaje']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
