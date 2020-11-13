import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapa_app/models/viajes_response.dart';
import 'package:mapa_app/services/preference_usuario.dart';

class ViajesService {
  final _prefs = new PreferenciasUsuario();
  final _local = 'http://localhost:8888/mapas-api/public';
  final _prod = 'https://mapas-server.herokuapp.com';
  List<Datum> viajes = [];

  // final _prod = 'ruta-server';
  Future<List<Datum>> listaViajes() async {
    final miUrl = '$_prod/api/get-viajes/1';

    final resp = await http.get(miUrl);
    final viajesResponse = viajesResponseFromJson(resp.body);

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    print(viajesResponse);
    final newsResponse = viajesResponseFromJson(resp.body);
    viajes = newsResponse.data;

    return viajes;
  }

  Future<Map<String, dynamic>> guardarViaje(
      double km, String horaInicio, String horaFinal, double precio) async {
    final data = {
      'km': km.toDouble(),
      'hora_inicio': horaInicio,
      'hora_termino': horaFinal,
      'precio': precio.toDouble(),
      'id_chofer': 1.toInt(),
      'usuario_creacion': 1.toInt()
    };
    print('===' + json.encode(data));

    final resp = await http.post('$_prod/api/store-viaje',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: jsonEncode(data));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if (decodedResp['ok'] == true) {
      return {'ok': true, 'mensaje': decodedResp['data']};
    }
    return {'ok': false, 'mensaje': 'No se pude establecer la conexion'};
  }
}
