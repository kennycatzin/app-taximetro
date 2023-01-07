import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/services/socket_service.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/user_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Desea salir de la aplicación?'),
            actions: <Widget>[
              new ElevatedButton.icon(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0)),
                // color: Colors.redAccent,
                // textColor: Colors.white,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                label: Text('Si'),
                icon: Icon(Icons.check_circle),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: Colors.redAccent,
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(
          top: 90,
          left: 30,
          child: circulo,
        ),
        Positioned(
          top: -40,
          right: -30,
          child: circulo,
        ),
        Positioned(
          bottom: -50,
          right: -10,
          child: circulo,
        ),
        Positioned(
          bottom: 120,
          right: 20,
          child: circulo,
        ),
        Positioned(
          top: -50,
          left: -20,
          child: circulo,
        ),
        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'F.U.T.V.',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              )
            ],
          ),
        )
      ],
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
            margin: EdgeInsets.symmetric(vertical: 30),
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
                  'Ingreso',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 60.0),
                _crearEmail(),
                SizedBox(height: 30.0),
                _crearPassword(),
                SizedBox(height: 30.0),
                _crearBoton()
              ],
            ),
          ),
          Text('¿ Olvidó la contraseña ?'),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton(
        // padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        child: Container(
          child: Text('Ingresar'),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        // elevation: 0.0,
        // color: Colors.redAccent,
        // textColor: Colors.white,
        onPressed: _login);
  }

  Widget _crearEmail() {
    // StreamBuilder es la contruccion dinámica en cuanto a las validaciones del bloc

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: this.emailCtrl,
        decoration: InputDecoration(
          icon: Icon(
            Icons.local_taxi,
            color: Colors.redAccent,
          ),
          labelText: 'Usuario',
        ),
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
          controller: this.passCtrl,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(
              Icons.lock,
              color: Colors.redAccent,
            ),
            labelText: 'Contraseña',
          )),
    );
  }

  _login() async {
    mostrarLoading(context);
    Map info = await usuarioProvider.login(
        this.emailCtrl.text.toString(), this.passCtrl.text.toString());
    Navigator.pop(context);

    if (info['ok'] == 'true') {
      final mapaBloc = BlocProvider.of<UsuarioBloc>(context);
      final tarifaBloc = BlocProvider.of<TarifaBloc>(context);
      final socketService = Provider.of<SocketService>(context, listen: false);
      final miMapa = BlocProvider.of<MapaBloc>(context);
      // socketService.connect();

      miMapa.add(OnTipoMapa(info['data']['operador']["id_centro_trabajo"]));
      mapaBloc.add(OnLogin(
          true,
          info['data']['operador']["id"],
          true,
          info['data']['operador']["imagen"],
          info['data']['operador']["centro_imagen"],
          info['data']['operador']["NumEconomico"],
          info['data']['operador']["TituloSindical"],
          info['data']['operador']["nombre"],
          info['data']['operador']["id_status"],
          info['data']['operador']["centro_trabajo"],
          info['data']['operador']["id_centro_trabajo"]));

      tarifaBloc.add(OnAsignarPrecios(
          info['data']['tarifas']["tarifa_minima"].toDouble(),
          info['data']['tarifas']["banderazo"].toDouble(),
          info['data']['tarifas']["intervalo_tiempo"],
          info['data']['tarifas']["intervalo_distancia"],
          info['data']['tarifas']["tarifa_tiempo"].toDouble(),
          info['data']['tarifas']["horarios"].toList()));
      Navigator.pushReplacementNamed(context, 'loading');
    } else if (info['ok'] == 'false') {
      mostrarAlerta(context, info['mensaje']);
    } else if (info['ok'] == "pago") {
      mostrarAlerta(context, 'Falta de pago, favor de pasar a la secretaria.');
    }
  }
}
