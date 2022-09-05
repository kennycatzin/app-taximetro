import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/models/viajes_response.dart';
import 'package:mapa_app/services/preference_usuario.dart';

class ViajesService {
  final _prefs = new PreferenciasUsuario();
  final _local = 'http://localhost:8888/mapas-api/public';
  final _prod = 'https://mapas-server.herokuapp.com';
  List<Datum> viajes = [];

  // final _prod = 'ruta-server';
  Future<List<Datum>> listaViajes() async {
    final userId = await _prefs.usuarioID;
    final miUrl = '${Enviroment.apiUrlDev}/get-viajes/' + userId.toString();
    print(miUrl);

    final resp = await http.get(Uri.parse(miUrl));
    final viajesResponse = viajesResponseFromJson(resp.body);

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    print(viajesResponse);
    final newsResponse = viajesResponseFromJson(resp.body);
    viajes = newsResponse.data;

    return viajes;
  }

  Future<bool> verificarEstatus(int id_viaje) async {
    final userId = await _prefs.usuarioID;
    bool pagado = false;
    final miUrl =
        '${Enviroment.apiUrlDev}/get-estatus-viaje/' + id_viaje.toString();
    print(miUrl);

    final resp = await http.get(Uri.parse(miUrl));
    if (resp.statusCode == 200) {
      Map<String, dynamic> decodedResp = json.decode(resp.body);
      if (decodedResp["data"]["Estatus"] == "POR PAGAR") {
        pagado = false;
      } else if (decodedResp["data"]["Estatus"] == "PAGADO") {
        pagado = true;
      }
    }

    return pagado;
  }

  Future<Map<String, dynamic>> guardarViaje(double km, String horaInicio,
      String horaFinal, double precio, int tipo, double pago_tiempo) async {
    final userId = await _prefs.usuarioID;
    final data = {
      'km': km.toDouble(),
      'hora_inicio': horaInicio,
      'hora_termino': horaFinal,
      'precio': precio.toDouble(),
      'id_chofer': userId.toInt(),
      'usuario_creacion': _prefs.usuarioID.toInt(),
      'tipo_viaje': tipo.toInt(),
      'precio_tiempo_espera': pago_tiempo.toDouble()
    };

    final resp =
        await http.post(Uri.parse('${Enviroment.apiUrlDev}/store-viaje'),
            headers: {
              "Content-Type": "application/json; charset=utf-8",
            },
            body: jsonEncode(data));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if (decodedResp['ok'] == true) {
      return {
        'ok': true,
        'mensaje': decodedResp['data'],
        'id_viaje': decodedResp['id_viaje']
      };
    }
    return {'ok': false, 'mensaje': 'No se pude establecer la conexion'};
  }

  Future<Map<String, dynamic>> guardarUbicacion(
      String latitud, String longitud) async {
    final userId = await _prefs.usuarioID;
    final data = {
      'id_usuario': userId.toInt(),
      'latitud': latitud,
      'longitud': longitud
    };

    final resp =
        await http.post(Uri.parse('${Enviroment.apiUrlDev}/store-ubicacion'),
            headers: {
              "Content-Type": "application/json; charset=utf-8",
            },
            body: jsonEncode(data));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if (decodedResp['ok'] == true) {
      return {'ok': true, 'mensaje': decodedResp['message']};
    }
    return {'ok': false, 'mensaje': 'No se pude establecer la conexion'};
  }
}
