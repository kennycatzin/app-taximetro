import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/supervisor_service.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'dart:convert';

class CapturaSupervisorPage extends StatefulWidget {
  @override
  _CapturaSupervisorPageState createState() => _CapturaSupervisorPageState();
}

@override
class _CapturaSupervisorPageState extends State<CapturaSupervisorPage> {
  final supervisorService = new SupervisorService();
  final placasCtrl = TextEditingController();
  final operadorCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();
  final rutaCtrl = TextEditingController();
  final notasCtrl = TextEditingController();

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Rutas nocturnas'),
            backgroundColor: Colors.redAccent,
          ),
          body: Container(child: _loginForm(context))),
    );
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
                _crearOperador(),
                SizedBox(height: 30.0),
                _crearPlacas(),
                SizedBox(height: 30.0),
                _crearRuta(),
                SizedBox(height: 30.0),
                _crearNotas(),
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
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        child: Container(
          child: Text(
            'Guardar',
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () => _saveRuta()
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

  Widget _crearPlacas() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: this.placasCtrl,
        decoration: InputDecoration(
          icon: Icon(
            Icons.directions_car_filled,
            color: Colors.redAccent,
          ),
          labelText: 'Placas',
        ),
      ),
    );
  }

  Widget _crearOperador() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: this.operadorCtrl,
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_circle,
            color: Colors.redAccent,
          ),
          labelText: 'Nombre operador',
        ),
      ),
    );
  }

  Widget _crearRuta() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: this.rutaCtrl,
        decoration: InputDecoration(
          icon: Icon(
            Icons.directions,
            color: Colors.redAccent,
          ),
          labelText: 'Ruta',
        ),
      ),
    );
  }

  Widget _crearFecha() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.datetime,
        controller: this.fechaCtrl,
        decoration: InputDecoration(
          icon: Icon(
            Icons.date_range,
            color: Colors.redAccent,
          ),
          labelText: 'Fecha',
        ),
      ),
    );
  }

  Widget _crearNotas() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        maxLines: 3,
        keyboardType: TextInputType.text,
        controller: this.notasCtrl,
        decoration: InputDecoration(
          icon: Icon(
            Icons.note_alt,
            color: Colors.redAccent,
          ),
          labelText: 'Observaciones',
        ),
      ),
    );
  }

  _saveRuta() async {
    mostrarLoading(context);
    Map info = await supervisorService.guardarRuta(
        this.placasCtrl.text.toString(),
        this.operadorCtrl.text.toString(),
        this.fechaCtrl.text.toString(),
        this.rutaCtrl.text.toString(),
        this.notasCtrl.text.toString());
    Navigator.pop(context);

    if (info['ok'] == true) {
      mostrarAlerta(context, info['mensaje']);
      this.placasCtrl.text = "";
      this.operadorCtrl.text = "";
      this.fechaCtrl.text = "";
      this.rutaCtrl.text = "";
      this.notasCtrl.text = "";
    } else if (info['ok'] == false) {
      mostrarAlerta(context, info['mensaje']);
    }
  }
}
