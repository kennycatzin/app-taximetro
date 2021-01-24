import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'package:mapa_app/widgets/lista_mensaje.dart';
import 'package:mapa_app/widgets/lista_viajes.dart';

class MensajesPage extends StatefulWidget {
  @override
  _MensajesPageState createState() => _MensajesPageState();
}

@override
class _MensajesPageState extends State<MensajesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  final viajesService = new ViajesService();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text('Mensajes del día'),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(child: _swipedTarjetas()));
  }

  Widget _swipedTarjetas() {
    return FutureBuilder(
        future: viajesService.listaViajes(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return ListaMensaje(snapshot.data);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
