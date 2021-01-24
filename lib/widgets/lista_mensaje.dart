import 'package:flutter/material.dart';
import 'package:mapa_app/models/viajes_response.dart';

class ListaMensaje extends StatelessWidget {
  final List<Datum> viajes;

  const ListaMensaje(this.viajes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.viajes.length,
      itemBuilder: (BuildContext context, int index) {
        return _Viaje(
          viaje: this.viajes[index],
          index: index,
        );
      },
    );
  }
}

class _Viaje extends StatelessWidget {
  final Datum viaje;
  final int index;

  const _Viaje({@required this.viaje, @required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Nombre usuario'),
      subtitle: Text('Correo usuario'),
      leading: CircleAvatar(
        child: Text('KC'),
        // usuario.nombre.substring(0, 2)
        backgroundColor: Colors.red[600],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            // color: usuario.online ? Colors.green[300] : Colors.red,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        // final chatService = Provider.of<ChatService>(context, listen: false);
        // chatService.usuarioPara = usuario;
        // Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
