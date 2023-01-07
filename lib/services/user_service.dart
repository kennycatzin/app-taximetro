import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/services/preference_usuario.dart';

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyDZCaIJhlOyJxgksAQ2doZ-GY-mie7t0Y8';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {'usuario': email, 'password': password};

    final resp = await http.post(Uri.parse('${Enviroment.apiUrlDev}/login'),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: jsonEncode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if (decodedResp.containsKey('token')) {
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
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
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
    if (token == "") {
      this.logout();
      return {'ok': 'invalido'};
    }
    final miId = await this._prefs.usuarioID;
    final query = '${Enviroment.apiUrlDev}/renovar-token';
    final resp = await http.get(Uri.parse(query), headers: {
      'Content-Type': 'application/json',
      'x-token': token,
      'id': miId.toString()
    });
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
    _prefs.usuarioID = 0;
  }
}
