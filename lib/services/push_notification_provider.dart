import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mapa_app/services/preference_usuario.dart';

// cbCyu2qKSGywdWyXGObZSe:APA91bFAlFJPvzaFoZLhgwAA4OuBJlUG2kr6jtKi6KTCxFVMynkELTO-I0AQPVdj-OIuyE5naidlOP1w9x59nECp2wVezdCpDLueZbkkiUEp_Es8EEu9QOqotKdhSTiZewfIbpGYzagM
class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotifictions() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();
    final prefs = new PreferenciasUsuario();

    print('=== FCM Token ====');
    print('125-  $token');
    prefs.tokenPushNotify = token;

    _firebaseMessaging.configure(
        onMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
        onLaunch: onLaunch,
        onResume: onResume);
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print('==== On Message ====');
    print('Message $message');
    final argumento = message['data']['comida'] ?? 'no data';
    print(argumento);
    _mensajesStreamController.sink.add(argumento);
    // Or do other work.
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('==== On Launch ====');
    final argumento = message['data']['comida'] ?? 'no data';
    print(argumento);

    _mensajesStreamController.sink.add(argumento);
    // Or do other work.
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('==== On Resume ====');
    final argumento = message['data']['comida'] ?? 'no data';
    print(argumento);

    _mensajesStreamController.sink.add(argumento);
    // Or do other work.
  }

  diposer() {
    _mensajesStreamController?.close();
  }
}
