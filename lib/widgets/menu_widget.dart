import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/global/globales.dart';
import 'package:mapa_app/services/socket_service.dart';
import 'package:mapa_app/services/user_service.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/menu-img.jpg'),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(
              Icons.airplanemode_active_rounded,
              color: Colors.redAccent,
            ),
            title: Text('Reporte de viajes'),
            onTap: () => Navigator.pushNamed(context, 'viajes'),
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: Colors.redAccent,
            ),
            title: Text('Mis mensajes'),
            onTap: () {
              Navigator.pushNamed(context, 'mensajes');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.car_repair,
              color: Colors.redAccent,
            ),
            title: Text('Viaje por tarifa'),
            onTap: () {
              Navigator.pushNamed(context, 'viaje_manual');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.redAccent,
            ),
            title: Text('Salir'),
            onTap: () {
              // Navigator.pop(context);
              _alertaConfirmacionInicio(context);
            },
          ),
          ListTile(
            title: Center(
              child: Text(
                Globales.versionProyecto,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            onTap: () {
              // Navigator.pop(context);
              _alertaConfirmacionInicio(context);
            },
          )
        ],
      ),
    );
  }

  void _alertaConfirmacionInicio(BuildContext context) {
    // set up the buttons
    Widget cancelButton = RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.red,
      textColor: Colors.white,
      label: Text('No'),
      icon: Icon(Icons.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.green,
      textColor: Colors.white,
      label: Text('Si'),
      icon: Icon(Icons.check_circle),
      onPressed: () {
        final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
        final mapaBloc = BlocProvider.of<MapaBloc>(context);
        final authService = new UsuarioProvider();
        authService.logout();

        taxiBloc.add(OnIniciarValores());
        mapaBloc.add(OnQuitarPoliline());
        mapaBloc.add(OnMapaCrea());

        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, 'login');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("¿Desea salir de la aplicación?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
