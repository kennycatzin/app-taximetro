import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mensaje/mensaje_bloc.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/global/enviroment.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'dart:convert';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';

class Comprobante extends StatefulWidget {
  static final String routeName = 'loading';

  @override
  _Comprobante createState() => _Comprobante();
}

class _Comprobante extends State<Comprobante> {
  var conf_telefono = TextEditingController();
  var telefono = TextEditingController();
  bool enviado = false;
  bool parar = false;
  final viajeProvider = new ViajesService();
  int tipo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Viaje por tarifa'),
            backgroundColor: Colors.redAccent,
          ),
          body: Container(child: _loginForm(context))),
    );
  }

  void verificarTipo(BuildContext context) async {
    print("entrando a revisar");
    final mensajeBloc = BlocProvider.of<MensajeBloc>(context).state;
    this.conf_telefono.text = mensajeBloc.telefono;
    this.telefono.text = mensajeBloc.telefono;
    // abrir modal
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mensajeBloc = BlocProvider.of<MensajeBloc>(context).state;
    print(mensajeBloc.telefono);
    (mensajeBloc.telefono != null)
        ? (this.conf_telefono.text = mensajeBloc.telefono)
        : '';
    (mensajeBloc.telefono != null)
        ? (this.telefono.text = mensajeBloc.telefono)
        : '';

    // abrir modal
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * .85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  'Ingrese los datos',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 50.0),
                _crearNumero(),
                SizedBox(height: 30.0),
                _crearTarifa(),
                SizedBox(height: 30.0),
                _crearBoton()
              ],
            ),
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearBoton() {
    final mensajeBloc = BlocProvider.of<MensajeBloc>(context).state;
    final id_viaje = mensajeBloc.viajeID;

    return RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 17.0),
        child: Container(
          child: Text(
            'Enviar',
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 0.0,
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: () => _send(
            "Para descargar tu comprobante, ingrese al siguiente enlace: " +
                Enviroment.urlPagoLinea +
                "?token=" +
                this.convertir(id_viaje.toString()),
            this.telefono.text)
        // onPressed: () => {
        //   showCupertinoModalBottomSheet(
        //       context: context, builder: (context) => Container())

        );
  }

  String convertir(String cadena) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(cadena); // dXNlcm5hbWU6cGFzc3dvcmQ=

    return encoded;
  }

  void _send(String message, String numero) async {
    if (this.telefono.text == this.conf_telefono.text) {
      enviado = true;
      print("mi numero es: " + this.telefono.text + message);
      var uri = 'sms:' + numero + '?body=' + message;

      await launch(uri);
      Navigator.pushReplacementNamed(context, 'loading');

      // String _result = await sendSMS(message: message, recipients: recipents)
      //     .catchError((onError) {
      //   // enviado = false;
      //   print(onError);
      // });
      // // crear funcion que verifique que se ha pagado mediante un clock

      // print(_result);
    } else {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cerrar"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Los numeros no coinciden"),
        actions: [
          cancelButton,
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

  void pagar() {
    enviado = true;
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
    final miTarifa = BlocProvider.of<TarifaBloc>(context).state;

    // if (this.precio.text == "") {
    //   this.precio.text = "0.0";
    // }
    // if (double.parse(this.precio.text) >= miTarifa.tarifaMinima) {
    //   print("mi numero es: " + this.precio.text);
    //   DateTime hora = DateTime.now();
    //   String horaReal = '${hora.hour}:${hora.minute}:${hora.second}';
    //   if (this.distancia.text == "") {
    //     this.distancia.text = "0.0";
    //   }
    //   taxiBloc.add(OnViajeManual(double.parse(this.distancia.text),
    //       double.parse(this.precio.text), 0, horaReal, horaReal));
    //   enviado = false;
    //   parar = false;
    //   Navigator.pushNamed(context, 'cobro');

    //   // guardar viaje
    // } else {
    //   enviado = false;
    //   // set up the buttons
    //   Widget cancelButton = FlatButton(
    //     child: Text("Cerrar"),
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //   );

    //   // set up the AlertDialog
    //   AlertDialog alert = AlertDialog(
    //     title: Text("El viaje debe ser mayor a ${miTarifa.tarifaMinima}"),
    //     actions: [
    //       cancelButton,
    //     ],
    //   );
    //   // show the dialog
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }
  }

  Widget _crearTarifa() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: this.telefono,
        decoration: InputDecoration(
          icon: Icon(
            Icons.phone_android,
            color: Colors.redAccent,
          ),
          labelText: 'Confirmar número',
        ),
      ),
    );
  }

  Widget _crearNumero() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: this.conf_telefono,
        decoration: InputDecoration(
          icon: Icon(
            Icons.phone_android,
            color: Colors.redAccent,
          ),
          labelText: 'Número telefónico',
        ),
      ),
    );
  }
}
