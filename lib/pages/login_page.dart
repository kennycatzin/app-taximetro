import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
                'Kenny Catzin',
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
                _crearBoton(context)
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

  Widget _crearBoton(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
      child: Container(
        child: Text('Ingresar'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: Colors.redAccent,
      textColor: Colors.white,
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'loading');
      },
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(
              Icons.local_taxi,
              color: Colors.redAccent,
            ),
            hintText: 'ejemplo@correo.com',
            labelText: 'Usuario'),
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            icon: Icon(
              Icons.lock,
              color: Colors.redAccent,
            ),
            labelText: 'Contraseña'),
      ),
    );
  }
}
