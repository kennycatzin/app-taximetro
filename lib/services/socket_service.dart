import 'package:flutter/material.dart';
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/services/preference_usuario.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  final _prefs = new PreferenciasUsuario();
  SocketService() {}

  void _initConfig() async {
    // this._socket = await IO.io('http://10.0.2.2:8080', {
    //   'transports': ['websocket'],
    //   'autoConnect': true,
    //   'forceNew': true
    // });
    // await this._socket.on('connecting', (_) {
    //   this._serverStatus = ServerStatus.Online;
    //   notifyListeners();
    // });
    // print('no se si conecteeeee....');
  }

  void connect() {
    print('conectare....');
    try {
      // this._socket = IO.io(Enviroment.socketUrlProd, {
      //   //.setTransports(['websocket'])
      // });
      // this._socket.on('connect', (_) {
      //   this._serverStatus = ServerStatus.Online;
      //   print('=== connect ===');
      //   notifyListeners();
      // });
      this._socket = io(Enviroment.socketUrlProd, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      // this._socket.connect();

      this._socket.onConnect((_) {
        this._serverStatus = ServerStatus.Online;
        print('=== connect ===');
        notifyListeners();
      });
      this._socket.on('disconnect', (_) {
        this._serverStatus = ServerStatus.Offline;
        print('=== connect ===');
        notifyListeners();
      });

      print('no se si conecteeeee....');
    } catch (e) {
      print(e);
    }

    // this._socket.on('connect', (_) {
    //   print('Conectando');
    //   this._serverStatus = ServerStatus.Online;
    //   notifyListeners();
    // });

    // this._socket.on('disconnect', (_) {
    //   this._serverStatus = ServerStatus.Offline;
    //   notifyListeners();
    // });
    // this._socket.on('marcador-nuevo', (_) {
    //   this._serverStatus = ServerStatus.Offline;
    //   notifyListeners();
    // });
  }

  void disconnect() {
    print("desconectando");
    this._serverStatus = ServerStatus.Offline;
    this._socket.disconnected;
  }
}
