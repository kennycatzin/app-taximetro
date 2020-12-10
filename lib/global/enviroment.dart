import 'dart:io';

class Enviroment {
  static String apiUrlDev = Platform.isAndroid
      ? 'http://10.0.2.2:3000/api'
      : 'http://localhost:3000/api';

  static String socketUrlDev =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

  static String apiUrlProd = Platform.isAndroid
      ? 'http://10.0.2.2:3000/api'
      : 'http://localhost:3000/api';

  static String socketUrlProd =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
}
