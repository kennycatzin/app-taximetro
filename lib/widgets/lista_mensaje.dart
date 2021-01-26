import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mensaje/mensaje_bloc.dart';
import 'package:mapa_app/models/mensajes_response.dart';

class ListaMensaje extends StatelessWidget {
  final List<Mensaje> mensajes;

  const ListaMensaje(this.mensajes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.mensajes.length,
      itemBuilder: (BuildContext context, int index) {
        return _Mensaje(
          mensaje: this.mensajes[index],
          index: index,
        );
      },
    );
  }
}

class _Mensaje extends StatelessWidget {
  final Mensaje mensaje;
  final int index;

  const _Mensaje({@required this.mensaje, @required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${mensaje.titulo}'),
      subtitle: Text(
        '${mensaje.mensaje}',
        overflow: TextOverflow.ellipsis,
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
        decoration: BoxDecoration(
            // color: usuario.online ? Colors.green[300] : Colors.red,
            color: (mensaje.idStatus == 5) ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        print(this.mensaje.name);
        final mensajeBloc = BlocProvider.of<MensajeBloc>(context);
        mensajeBloc.add(OnTapMensaje(
            this.mensaje.idMensaje,
            this.mensaje.titulo,
            this.mensaje.mensaje,
            this.mensaje.tipo,
            this.mensaje.name));
        Navigator.pushNamed(context, 'detalle_mensaje');
      },
    );
  }
}
