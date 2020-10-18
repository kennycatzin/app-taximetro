import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';

class CobroPage extends StatefulWidget {
  @override
  _CobroPageState createState() => _CobroPageState();
}

int _genero;

class _CobroPageState extends State<CobroPage> {
  @override
  Widget build(BuildContext context) {
    final taxiBloc = context.bloc<TaximetroBloc>().state;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));

    // return Scaffold(
    //   body: Container(
    //     height: size.height * .38,
    //     width: double.infinity,
    //     color: Colors.green,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Container(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 'Total a pagar',
    //                 style: TextStyle(color: Colors.white, fontSize: 30),
    //               ),
    //               Icon(
    //                 Icons.attach_money,
    //                 color: Colors.white,
    //                 size: 35,
    //               ),
    //               Text(
    //                 '200',
    //                 style: TextStyle(color: Colors.white, fontSize: 35),
    //               )
    //             ],
    //           ),
    //         ),
    //         Container()
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _crearFondo(BuildContext context) {
    final taxiBloc = context.bloc<TaximetroBloc>().state;

    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: Colors.green,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total a pagar',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 35,
              ),
              Text(
                '${taxiBloc.pago}',
                style: TextStyle(color: Colors.white, fontSize: 35),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final taxiBloc = context.bloc<TaximetroBloc>().state;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 60.0,
            ),
          ),
          Container(
            width: size.width * .85,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(vertical: 30.0),
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
                  'Detalle de viaje',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_outlined,
                      size: 18,
                    ),
                    Text(
                      'Distancia recorrida: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${taxiBloc.km}',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_rounded,
                      size: 18,
                    ),
                    Text(
                      'Hora inicial: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '12:30:45',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: 10.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 18,
                    ),
                    Text(
                      'Hora Final: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '12:58:45',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       RadioListTile(
                //         value: 1,
                //         title: Text('Masculino'),
                //         groupValue: _genero,
                //         onChanged: _setSelectedRadio,
                //       ),
                //       RadioListTile(
                //           value: 2,
                //           title: Text('Femenino'),
                //           groupValue: _genero,
                //           onChanged: _setSelectedRadio),
                //     ]),
                SizedBox(height: 10.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 18,
                          ),
                          Text(
                            'Tarjeta',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.money,
                            size: 18,
                          ),
                          Text(
                            'Efectivo',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_taxi,
                            size: 18,
                          ),
                          Text(
                            'Monedero',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),

                //_crearEmail(),
                //_crearPassword(),
                _crearBoton(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  _setSelectedRadio(int valor) {
    _genero = valor;
    setState(() {});
  }

  Widget _crearBoton(BuildContext context) {
    final taxiBloc = context.bloc<TaximetroBloc>();
    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;

    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
      child: Container(
        child: Text('Regresar'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: () {
        taxiBloc.add(OnStartIsPressed(inicio));
        Navigator.pushNamedAndRemoveUntil(context, 'loading', (_) => false);
      },
    );
  }
}
