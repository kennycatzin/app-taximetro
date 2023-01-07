import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagadoPage extends StatefulWidget {
  @override
  _PagadoPageState createState() => _PagadoPageState();
}

@override
class _PagadoPageState extends State<PagadoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("salgo de aqui");
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Confirmación de pago'),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('./assets/correcto.png'),
                      width: 80,
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'El pago ha sido aplicado correctamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              this._crearBoton()
            ],
          ),
        )));
  }

  Widget _crearBoton() {
    return ElevatedButton(
        // padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
        child: Container(
          child: Text('Regresar'),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        // elevation: 0.0,
        // color: Colors.redAccent,
        // textColor: Colors.white,
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'loading');
        });
  }
}
