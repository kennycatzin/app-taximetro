import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mensaje/mensaje_bloc.dart';
import 'package:mapa_app/services/mensaje_service.dart';

import 'package:mapa_app/services/preference_usuario.dart';
import 'package:mapa_app/services/viajes_service.dart';

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
    final size = MediaQuery.of(context).size;
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
    return ListTile(
      title: Text('${mensaje.titulo}'),
      subtitle: Text(
        '${mensaje.mensaje}',
      ),
      leading: CircleAvatar(
        child: Text((mensaje.tipo == 1)
            ? 'CC'
            : (mensaje.tipo == 2)
                ? 'TG'
                : 'TP'),
        // usuario.nombre.substring(0, 2)
        backgroundColor: Colors.red[600],
      ),
      trailing: Container(
        width: 10,
        height: 10,
      ),
      onTap: () {},
    );
  }
}
