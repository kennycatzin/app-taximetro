import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';

// cbCyu2qKSGywdWyXGObZSe:APA91bFAlFJPvzaFoZLhgwAA4OuBJlUG2kr6jtKi6KTCxFVMynkELTO-I0AQPVdj-OIuyE5naidlOP1w9x59nECp2wVezdCpDLueZbkkiUEp_Es8EEu9QOqotKdhSTiZewfIbpGYzagM
class PushNotificationsProvider {
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    return message;
  }

  Future<void> initNotifictions() async {
    // await _firebaseMessaging.requestNotificationPermissions();
    //  final token = await _firebaseMessaging.getToken();
    print('=== FCM Token ====');
    // print('125-  $token');
    // prefs.tokenPushNotify = token;

    //   _firebaseMessaging.configure(
    //       onMessage: onMessage,
    //       onBackgroundMessage: onBackgroundMessage,
    //       onLaunch: onLaunch,
    //       onResume: onResume);
    // }

  }

  void dispose() {
    _mensajesStreamController.close();
  }
}
