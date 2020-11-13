import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/login/login.dart';
import 'package:mapa_app/bloc/login/provider.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/user_service.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
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
    final bloc = Provider.of(context);
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
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
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

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
            child: Container(
              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.redAccent,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null);
      },
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    // StreamBuilder es la contruccion dinámica en cuanto a las validaciones del bloc
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.local_taxi,
                  color: Colors.redAccent,
                ),
                labelText: 'Usuario',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.redAccent,
                ),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    mostrarLoading(context);

    Map info = await usuarioProvider.login(bloc.email, bloc.password);
    Navigator.pop(context);

    if (info['ok'] == 'true') {
      print(info['data']['operador']["imagen"]);
      final mapaBloc = context.bloc<UsuarioBloc>();
      final tarifaBloc = context.bloc<TarifaBloc>();

      mapaBloc.add(OnLogin(
          true,
          info['data']['operador']["imagen"],
          info['data']['operador']["NumEconomico"],
          info['data']['operador']["TituloSindical"],
          info['data']['operador']["nombre"]));

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
