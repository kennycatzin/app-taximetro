import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/preference_usuario.dart';
import 'package:mapa_app/services/viajes_service.dart';

class CobroPage extends StatefulWidget {
  static final String routeName = 'loading';

  @override
  _CobroPageState createState() => _CobroPageState();
}

class _CobroPageState extends State<CobroPage> {
  final prefs = new PreferenciasUsuario();
  final viajeProvider = new ViajesService();

  @override
  void initState() {
    super.initState();
    prefs.ultimaPagina = CobroPage.routeName;
  }

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
                '${taxiBloc.pago.toStringAsFixed(2)}',
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
            width: size.width * .70,
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
                SizedBox(height: 25.0),
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
                      '${taxiBloc.km.toStringAsFixed(3)} KM',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.money,
                      size: 18,
                    ),
                    Text(
                      'Total cobro espera: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${taxiBloc.pagoTiempo.toStringAsFixed(3)}',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),

                SizedBox(height: 6.0),
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
                      '${taxiBloc.horaInicio}',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: 6.0),

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
                      '${taxiBloc.horaFinal}',
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
                          RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.redAccent,
                              textColor: Colors.white,
                              label: Text('Tarjeta'),
                              icon: Icon(Icons.credit_card),
                              onPressed: null)
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [_crearBoton(context)],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            label: Text('Monedero'),
                            icon: Icon(Icons.wallet_giftcard),
                            onPressed: null,
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                //_crearEmail(),
                //_crearPassword(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text('Efectivo'),
      icon: Icon(Icons.money),
      onPressed: () {
        botonEfectivo(context);
      },
    );
  }

  void botonEfectivo(BuildContext context) async {
    mostrarLoading(context);
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    Map info = await viajeProvider.guardarViaje(
        taxiBloc.state.km,
        taxiBloc.state.horaInicio,
        taxiBloc.state.horaFinal,
        taxiBloc.state.pago);
    Navigator.pop(context);
    if (info['ok'] == true) {
      taxiBloc.add(OnIniciarValores());
      mapaBloc.add(OnQuitarPoliline());
      mapaBloc.add(OnMapaCrea());
      Navigator.pushReplacementNamed(context, 'loading');
    } else if (info['ok'] == false) {
      mostrarAlerta(context, info['mensaje']);
    }
  }
}
