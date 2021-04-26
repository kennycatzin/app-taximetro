import 'dart:io';

class Enviroment {
  final miUrlHeroku = "https://mapas-server.herokuapp.com/api";
  final miUrlProd = "https://mapas-server.herokuapp.com/api";
  final miUrlLocal = "http://10.0.2.2:8888/mapas-api/public/api";
  final miUrlPagoLinea = "http://10.0.2.2:8888/pagocurso/index.php";

  static String apiUrlDev = Platform.isAndroid
      ? 'https://mapas-server.herokuapp.com/api'
      : 'https://mapas-server.herokuapp.com/api';

  static String socketUrlDev =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  static String apiUrlProd = Platform.isAndroid
      ? 'https://mapas-server.herokuapp.com/api'
      : 'http://localhost:3000/api';

  static String socketUrlProd =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  static String urlPagoLinea = Platform.isAndroid
      ? 'http://192.168.1.93:8888/pagocurso/index.php'
      : 'http://192.168.1.93:8888/pagocurso/index.php';
}
// http://192.168.1.93:8888/pagocurso/index.php
