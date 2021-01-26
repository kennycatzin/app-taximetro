import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/services/preference_usuario.dart';

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyDZCaIJhlOyJxgksAQ2doZ-GY-mie7t0Y8';
  final _prefs = new PreferenciasUsuario();
  final _local = 'http://10.0.2.2:8888/mapas-api/public';
  final _prod = 'https://mapas-server.herokuapp.com';
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {'usuario': email, 'password': password};

    final resp = await http.post('${Enviroment.apiUrlDev}/login',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: jsonEncode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('token')) {
      // TODO salvar el token en el sstorage
      _prefs.token = decodedResp['token'];
      _prefs.usuarioID = decodedResp['operador']['id'];
      return {'ok': 'true', 'token': decodedResp['token'], 'data': decodedResp};
    } else {
      if (decodedResp['ok'] == "pago") {
        return {
          'ok': 'pago',
          'mensaje': "Favor de pasar a la secretaria para realizar el pago"
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

  Future<Map<String, dynamic>> isLoggedIn() async {
    final token = await this._prefs.token;
    final resp = await http.get('${Enviroment.apiUrlDev}/renovar-token',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      print(decodedResp);
      _prefs.token = decodedResp['token'];
      if (decodedResp.containsKey('token')) {
        // TODO salvar el token en el sstorage
        _prefs.token = decodedResp['token'];
        _prefs.usuarioID = decodedResp['operador']['id'];
        return {
          'ok': 'true',
          'token': decodedResp['token'],
          'data': decodedResp
        };
      } else {
        if (decodedResp['ok'] == "pago") {
          return {
            'ok': 'pago',
            'mensaje': "Favor de pasar a la secretaria para realizar el pago"
          };
        }
        return {'ok': 'false', 'mensaje': decodedResp['mensaje']};
      }
    } else {
      this.logout();
      return {'ok': 'invalido'};
    }
  }

  void logout() async {
    _prefs.token = '';
  }
}
