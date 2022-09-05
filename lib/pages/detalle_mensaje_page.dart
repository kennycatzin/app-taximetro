import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mensaje/mensaje_bloc.dart';
import 'package:mapa_app/services/mensaje_service.dart';

import 'package:mapa_app/services/preference_usuario.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleMensaje extends StatefulWidget {
  static final String routeName = 'loading';

  @override
  _DetalleMensajeState createState() => _DetalleMensajeState();
}

class _DetalleMensajeState extends State<DetalleMensaje> {
  final prefs = new PreferenciasUsuario();
  final viajeProvider = new ViajesService();
  final mensajeService = new MensajesService();

  @override
  void initState() {
    super.initState();
    // prefs.ultimaPagina = DetalleMensaje.routeName;
  }

  @override
  Widget build(BuildContext context) {
    final mensajeBloc = BlocProvider.of<MensajeBloc>(context).state;
    // final size = MediaQuery.of(context).size;
    final mensajeService = new MensajesService();
    mensajeService.mensajeVisto(mensajeBloc.id_mensaje);

    return Scaffold(
        appBar: AppBar(
          title: Text('Contenido del mensaje'),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child: contenidoMensaje(mensajeBloc),
          // child: Column(
          //   children: <Widget>[
          //     Column(
          //       children: <Widget>[
          //         Row(
          //           children: <Widget>[
          //             Text('Emisor: ${mensajeBloc.name}'),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 30,
          //         ),
          //         Row(
          //           children: <Widget>[
          //             Text('titulo: ${mensajeBloc.titulo}'),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 30,
          //         ),
          //         Row(
          //           children: <Widget>[
          //             Text('Mensaje: ${mensajeBloc.mensaje}'),
          //           ],
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ));
  }

  Widget contenidoMensaje(MensajeState mensaje) {
    return Column(
      children: [
        ListTile(
          title: Text(
            '${mensaje.titulo}',
            style: TextStyle(fontSize: 26, fontFamily: 'bold'),
          ),
          hoverColor: Colors.red,
          subtitle: Text(
            '${mensaje.mensaje}',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          leading: CircleAvatar(
            child: Text((mensaje.tipo)),
            // usuario.nombre.substring(0, 2)
            backgroundColor: Colors.red[600],
          ),
          trailing: Container(
            width: 10,
            height: 10,
          ),
          onTap: () {},
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            maxRadius: 25,
            child: IconButton(
              icon: Icon(Icons.call, color: Colors.white),
              onPressed: () {
                // mapaBloc.add( OnMarcarRecorrido() );
                launch(('tel://${mensaje.telefono}'));
              },
            ),
          ),
        ),
      ],
    );
  }
}
