import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/services/viajes_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CobroPage extends StatefulWidget {
  static final String routeName = 'loading';

  @override
  _CobroPageState createState() => _CobroPageState();
}

class _CobroPageState extends State<CobroPage> {
  final viajeProvider = new ViajesService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context).state;
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
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context).state;
    final operadorBloc = BlocProvider.of<UsuarioBloc>(context).state;
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
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.redAccent,
                              textColor: Colors.white,
                              label: Text(
                                  'Tarjeta \n \$ ${((((taxiBloc.pago * .029) + 2.5) * 1.16) + taxiBloc.pago).toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 18)),
                              icon: Icon(Icons.credit_card),
                              onPressed: (operadorBloc.id_status == 1)
                                  ? null
                                  : () => accionPago(context, 2))
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [_crearBoton(context)],
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
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context).state;
    return RaisedButton.icon(
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text('Efectivo \n\$ ${taxiBloc.pago.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18)),
      icon: Icon(Icons.money),
      onPressed: () {
        accionPago(context, 1);
      },
    );
  }

  void accionPago(BuildContext context, tipo) async {
    mostrarLoading(context);
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    Map info = await viajeProvider.guardarViaje(
        taxiBloc.state.km,
        taxiBloc.state.horaInicio,
        taxiBloc.state.horaFinal,
        taxiBloc.state.pago,
        tipo,
        taxiBloc.state.pagoTiempo);
    print(info);
    Navigator.pop(context);
    if (info['ok'] == true) {
      mapaBloc.add(OnQuitarPoliline());
      mapaBloc.add(OnMapaCrea());
      if (tipo == 1) {
        taxiBloc.add(OnIniciarValores());
        Navigator.pushReplacementNamed(context, 'loading');
      } else if (tipo == 2) {
        Navigator.pushReplacementNamed(context, 'tarjeta',
            arguments: {"id_viaje": info['id_viaje']});
      }
    } else if (info['ok'] == false) {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Future<bool> pagoClienteOChofer(int id_viaje) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Enviar link de pago al cliente?'),
            actions: <Widget>[
              new RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.redAccent,
                textColor: Colors.white,
                label: Text('No'),
                icon: Icon(Icons.cancel),
                onPressed: () {
                  // Abrir modal
                  CupertinoScaffold.showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Stack(
                      children: <Widget>[
                        Positioned(
                          height: 40,
                          left: 40,
                          right: 40,
                          bottom: 20,
                          child: MaterialButton(
                            onPressed: () => {
                              Navigator.pushReplacementNamed(
                                context,
                                'tarjeta',
                                arguments: {"id_viaje": id_viaje, "tipo": 0},
                              )
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              new RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.green,
                textColor: Colors.white,
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
