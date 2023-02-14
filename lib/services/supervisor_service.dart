import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/services/preference_usuario.dart';

class SupervisorService {
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> guardarRuta(String placas, String operador,
      String fecha, String ruta, String observaciones) async {
    final data = {
      'placas': placas,
      'fecha': fecha,
      'operador': operador,
      'ruta': ruta,
      'observaciones': observaciones,
      'usuario': _prefs.usuarioID.toInt()
    };
    final resp =
        await http.post(Uri.parse('${Enviroment.apiUrlDev}/store-ruta'),
            headers: {
              "Content-Type": "application/json; charset=utf-8",
            },
            body: jsonEncode(data));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if (decodedResp['ok'] == true) {
      return {'ok': true, 'mensaje': "Se ha guardado la ruta"};
    }
    return {'ok': false, 'mensaje': 'No pudo guardar la información'};
  }
}
