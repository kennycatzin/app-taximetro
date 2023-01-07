// token  para la notificacion
// fcDCIqr0T4a94RCcaHE_y5:APA91bEii_jRd41hMxHjLHZhSvkbiT5ZY66rt2l2ilq_-EADTUHmMA4zDD_f_1M1Mg7X3qifFcwLTOsV56EnnBlKjL6BjY0dEzXootCCdfX4cpnlW_XCwpvOQ7ZUphHez6fkDqW3LqxI

import 'package:flutter/material.dart';

class PushNotificacionesPage extends StatelessWidget {
  static final String routeName = 'notificacion';

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ventana de avisos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(arg), _crearBoton(context)],
        ),
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return ElevatedButton(
      // padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
      child: Container(
        child: Text('Regresar'),
      ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      // elevation: 0.0,
      // color: Colors.blueAccent,
      // textColor: Colors.white,
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'login');
      },
    );
  }
}
