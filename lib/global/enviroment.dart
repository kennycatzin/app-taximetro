import 'dart:io';

class Enviroment {
  final miUrlHeroku = "https://mapas-server.herokuapp.com/api";
  final miUrlProd = "https://mapas-server.herokuapp.com/api";
  final miUrlLocal = "http://10.0.2.2:8888/mapas-api/public/api";
  final miUrlPagoLinea = "http://10.0.2.2:8888/pagocurso/index.php";
  final miUrlSerteza = "https://taximetro.serteza.com/public/api";

  static String apiUrlDev = Platform.isAndroid
      ? 'https://taximetro.serteza.com/public/api'
      : 'hhttps://taximetro.serteza.com/public/api';

  static String socketUrlDev =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  static String apiUrlProd = Platform.isAndroid
      ? 'https://taximetro.serteza.com/public/api'
      : 'https://taximetro.serteza.com/public/api';

  static String socketUrlProd =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  static String urlPagoLinea = Platform.isAndroid
      ? 'https://pasarela.serteza.com'
      : 'https://pasarela.serteza.com';

  static String urlContrataPasarela = Platform.isAndroid
      ? 'http://contrata-pasarela.serteza.com/'
      : 'http://contrata-pasarela.serteza.com/';
}
// http://192.168.1.93:8888/pagocurso/index.php
