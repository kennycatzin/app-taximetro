import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sms/flutter_sms.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'package:mapa_app/global/enviroment.dart';
import 'dart:convert';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TarjetaPage extends StatefulWidget {
  @override
  _TarjetaPageState createState() => _TarjetaPageState();
}

@override
class _TarjetaPageState extends State<TarjetaPage> {
  final numero = TextEditingController();
  final confirmaNumero = TextEditingController();
  bool enviado = false;
  bool parar = false;
  Timer miTimer;
  final viajeProvider = new ViajesService();
  int id_viaje;
  int tipo;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    verificarTipo(context);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    this.id_viaje = int.parse(args["id_viaje"]);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Enviar mensaje'),
            backgroundColor: Colors.redAccent,
          ),
          body: Container(child: _loginForm(context))),
    );
  }

  void verificarTipo(BuildContext context) async {
    print("entrando a revisar");
    // abrir modal
  }

  void _send(String message, List<String> recipents) async {
    if (this.numero.text == this.confirmaNumero.text) {
      enviado = true;
      print("mi numero es: " + this.numero.text);
      String _result = await sendSMS(message: message, recipients: recipents)
          .catchError((onError) {
        // enviado = false;
        print(onError);
      });
      mostrarLoading(context);
      _verificar();
      // crear funcion que verifique que se ha pagado mediante un clock

      // print(_result);
    } else {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cerrar"),
        onPressed: () {},
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

  void _verificar() async {
    if (!this.parar) {
      miTimer = new Timer.periodic(Duration(seconds: 40), (timer) {
        print(DateTime.now());
        // verificar
        _getEstatus();
      });
    } else {
      print("termineeeeeee");
      miTimer.cancel();

      // Navigator.of(context).pop();
      //  Navigator.pushNamed(context, 'viajes');
    }
  }

  void _getEstatus() async {
    if (await viajeProvider.verificarEstatus(this.id_viaje)) {
      final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
      taxiBloc.add(OnIniciarValores());
      print("matar proceso");
      miTimer.cancel();
      this.parar = true;
      await Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, 'pagado');
    } else {
      this.parar = false;
    }
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  'Número telefónico',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 60.0),
                _crearNumero(),
                SizedBox(height: 30.0),
                _crearConfirmaNumero(),
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
    return ElevatedButton(
        // padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 17.0),
        child: Container(
          child: Text(
            !enviado ? 'Enviar' : 'Esperando confirmación \n de pago',
            textAlign: TextAlign.center,
          ),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        // elevation: 0.0,
        // color: Colors.redAccent,
        // textColor: Colors.white,
        onPressed: () => !enviado
            ? _send(
                "Para continuar con el pago en línea, ingrese al siguiente link: " +
                    Enviroment.urlPagoLinea +
                    "?token=" +
                    this.convertir(this.id_viaje.toString()),
                [this.numero.text])
            : {}
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

  Widget _crearNumero() {
    // StreamBuilder es la contruccion dinámica en cuanto a las validaciones del bloc

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        enabled: enviado ? false : true,
        keyboardType: TextInputType.number,
        controller: this.numero,
        decoration: InputDecoration(
          icon: Icon(
            Icons.phone_android,
            color: Colors.redAccent,
          ),
          labelText: 'Número',
        ),
      ),
    );
  }

  Widget _crearConfirmaNumero() {
    // StreamBuilder es la contruccion dinámica en cuanto a las validaciones del bloc

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        enabled: enviado ? false : true,
        keyboardType: TextInputType.number,
        controller: this.confirmaNumero,
        decoration: InputDecoration(
          icon: Icon(
            Icons.phone_android,
            color: Colors.redAccent,
          ),
          labelText: 'Confirma Número',
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Regresar al módulo de pago?'),
            actions: <Widget>[
              new ElevatedButton.icon(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0)),
                // color: Colors.redAccent,
                // textColor: Colors.white,
                label: Text('No'),
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              new ElevatedButton.icon(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0)),
                // color: Colors.green,
                // textColor: Colors.white,
                label: Text('Si'),
                icon: Icon(Icons.check_circle),
                onPressed: () {
                  if (enviado) {
                    miTimer.cancel();
                  }
                  Navigator.pushNamed(context, 'cobro');
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> pagoClienteOChofer(int id_viaje) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Enviar link de pago al cliente?'),
            actions: <Widget>[
              new ElevatedButton.icon(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0)),
                // color: Colors.redAccent,
                // textColor: Colors.white,
                label: Text('No'),
                icon: Icon(Icons.cancel),
                onPressed: () {
                  // Abrir modal
                  // CupertinoScaffold.showCupertinoModalBottomSheet(
                  //   expand: true,
                  //   context: context,
                  //   backgroundColor: Colors.transparent,
                  //   builder: (context) => Stack(
                  //     children: <Widget>[
                  //       Positioned(
                  //         height: 40,
                  //         left: 40,
                  //         right: 40,
                  //         bottom: 20,
                  //         child: MaterialButton(
                  //           onPressed: () => {
                  //             Navigator.pushReplacementNamed(
                  //               context,
                  //               'tarjeta',
                  //               arguments: {"id_viaje": id_viaje, "tipo": 0},
                  //             )
                  //           },
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // );
                },
              ),
              new ElevatedButton.icon(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0)),
                // color: Colors.green,
                // textColor: Colors.white,
                label: Text('Si'),
                icon: Icon(Icons.check_circle),
                onPressed: () {
                  // enviar mensaje
                  Navigator.pushReplacementNamed(context, 'tarjeta',
                      arguments: {"id_viaje": id_viaje, "tipo": 0});
                },
              ),
            ],
          ),
        )) ??
        false;
  }
}
