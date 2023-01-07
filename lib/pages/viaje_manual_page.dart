import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'dart:convert';

class ViajeManualPage extends StatefulWidget {
  @override
  _ViajeManualPageState createState() => _ViajeManualPageState();
}

@override
class _ViajeManualPageState extends State<ViajeManualPage> {
  final precio = TextEditingController();
  final distancia = TextEditingController();
  bool enviado = false;
  bool parar = false;
  final viajeProvider = new ViajesService();
  int id_viaje;
  int tipo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    this.id_viaje = 20;

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
    // abrir modal
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
                  'Ingrese los datos',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 50.0),
                _crearTarifa(),
                SizedBox(height: 30.0),
                _crearNumero(),
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
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        child: Container(
          child: Text(
            'Guardar',
            textAlign: TextAlign.center,
          ),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        // elevation: 0.0,
        // color: Colors.redAccent,
        // textColor: Colors.white,
        onPressed: () => !enviado ? pagar() : {}
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

  void pagar() {
    enviado = true;
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
    final miTarifa = BlocProvider.of<TarifaBloc>(context).state;

    if (this.precio.text == "") {
      this.precio.text = "0.0";
    }
    if (double.parse(this.precio.text) >= miTarifa.tarifaMinima) {
      print("mi numero es: " + this.precio.text);
      DateTime hora = DateTime.now();
      String horaReal = '${hora.hour}:${hora.minute}:${hora.second}';
      if (this.distancia.text == "") {
        this.distancia.text = "0.0";
      }
      taxiBloc.add(OnViajeManual(double.parse(this.distancia.text),
          double.parse(this.precio.text), 0, horaReal, horaReal));
      enviado = false;
      parar = false;
      Navigator.pushNamed(context, 'cobro');

      // guardar viaje
    } else {
      enviado = false;
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cerrar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("El viaje debe ser mayor a ${miTarifa.tarifaMinima}"),
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

  Widget _crearTarifa() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        enabled: enviado ? false : true,
        keyboardType: TextInputType.number,
        controller: this.precio,
        decoration: InputDecoration(
          icon: Icon(
            Icons.money,
            color: Colors.redAccent,
          ),
          labelText: 'Importe del viaje',
        ),
      ),
    );
  }

  Widget _crearNumero() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        enabled: enviado ? false : true,
        keyboardType: TextInputType.number,
        controller: this.distancia,
        decoration: InputDecoration(
          icon: Icon(
            Icons.add_location_alt_rounded,
            color: Colors.redAccent,
          ),
          labelText: 'Distancia en KM',
        ),
      ),
    );
  }
}
