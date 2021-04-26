import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/models/mensajes_response.dart';
import 'package:mapa_app/services/preference_usuario.dart';

class MensajesService {
  final _prefs = new PreferenciasUsuario();
  List<Mensaje> mensajes = [];

  // final _prod = 'ruta-server';
  Future<List<Mensaje>> listaMensajes() async {
    final userId = await _prefs.usuarioID;
    final miUrl = '${Enviroment.apiUrlDev}/get-mensajes/' + userId.toString();
    print(miUrl);
    final resp = await http.get(miUrl);
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    final newsResponse = mensajesResponseFromJson(resp.body);
    mensajes = newsResponse.mensajes;
    return mensajes;
  }

  Future<bool> mensajeVisto(int idMensaje) async {
    final miUrl =
        '${Enviroment.apiUrlDev}/mensaje-visto/' + idMensaje.toString();
    print(miUrl);
    final resp = await http.get(miUrl);

    if (resp.statusCode == 200) {
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      if (decodedResp['ok'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> aceptarViajeMensaje(int idViaje) async {
    final miUrl = '${Enviroment.apiUrlDev}/aceptar-viaje/' + idViaje.toString();
    print(miUrl);
    final resp = await http.get(miUrl);

    if (resp.statusCode == 200) {
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      print(decodedResp);

      if (decodedResp['ok'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> rechazarViajeMensaje(int idViaje) async {
    final miUrl =
        '${Enviroment.apiUrlDev}/rechazar-viaje/' + idViaje.toString();
    print(miUrl);
    final resp = await http.get(miUrl);
    print(resp);

    if (resp.statusCode == 200) {
      Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (decodedResp['ok'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> listaNuevoMensaje() async {
    final userId = await _prefs.usuarioID;
    final miUrl =
        '${Enviroment.apiUrlDev}/get-mensajes-nuevos/' + userId.toString();
    final resp = await http.get(miUrl);
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    return decodedResp;
  }
}
