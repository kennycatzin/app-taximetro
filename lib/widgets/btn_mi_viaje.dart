part of 'widgets.dart';

class BtnMiViaje extends StatefulWidget {
  const BtnMiViaje({Key key}) : super(key: key);

  @override
  _BtnMiViajeState createState() => _BtnMiViajeState();
}

class _BtnMiViajeState extends State<BtnMiViaje> {
  Timer miTimer;
  bool parartaximetro = true;
  bool iniciaViaje;
  bool accion = false;
  int contador = 0;
  DateTime horaActual;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // miTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaximetroBloc, TaximetroState>(
      builder: (context, state) => _crearBoton(context, state),
    );
  }

  Widget _crearBoton(BuildContext context, TaximetroState state) {
    final size = MediaQuery.of(context).size;
    return Container(
        margin:
            EdgeInsets.only(top: size.width * 0.39, left: size.height * .17),
        child: MaterialButton(
          onPressed: () {
            if (parartaximetro) {
              _alertaConfirmacionInicio(context, state);
              print(accion);
              if (accion) {
                _iniciarDetenerViaje(context, state);
              } else {
                return;
              }
            } else {
              _alertaConfirmacionDetener(context, state);
            }
          },
          color: Colors.redAccent,
          textColor: Colors.white,
          child: Icon(
            (state.startIsPressed) ? Icons.pause : Icons.play_arrow,
            size: 50,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ));
  }

  void _iniciarDetenerViaje(BuildContext context, TaximetroState state) async {
    final taximetoBloc = context.bloc<TaximetroBloc>();
    final busquedaBloc = context.bloc<BusquedaBloc>();
    final mapaBloc = context.bloc<MapaBloc>();
    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    String hora = DateFormat.jm().format(DateTime.now());

    mapaBloc.add(OnSeguirUbicacion());

    if (!state.startIsPressed) {
      busquedaBloc.add(OnActivarMarcadorManual());
      mapaBloc.add(OnCrearMarcadorInicio(inicio));
      mapaBloc.add(OnQuitarPoliline());
      mapaBloc.add(OnMarcarRecorrido());
      taximetoBloc.add(OnHoraInicio(hora));
      parartaximetro = false;
    } else {
      print('=== Voy a quitar markers ===');
      busquedaBloc.add(OnDesActivarMarcadorManual());
      mapaBloc.add(OnCrearMarcadorFinal(inicio));
      mapaBloc.add(OnQuitarMarcadores());
      taximetoBloc.add(OnHoraFinal(hora));
      mapaBloc.add(OnMarcarRecorrido());
      parartaximetro = true;
    }
    taximetoBloc.add(OnStartIsPressed(inicio));

    _cotizar(context, parartaximetro);
    if (state.startIsPressed) {
      print('== Debo ir a la pantalla pago ====');
      await _verificaPrecios(context);
      Future.delayed(Duration(milliseconds: 2000)).then((value) => {
            Navigator.pushNamed(context, 'cobro')

            //_mapController.showMarkerInfoWindow(MarkerId('final'))
          });
    }
  }

  void _cotizar(BuildContext context, bool parar) async {
    if (!parar) {
      miTimer = new Timer.periodic(const Duration(seconds: 20), (timer) {
        print(DateTime.now());
        _verificaPrecios(context);
      });
    } else {
      miTimer.cancel();
    }
  }

  void _verificaPrecios(BuildContext context) async {
    try {
      contador++;
//      final result = await InternetAddress.lookup('api.mapbox.com');
      //    if (result.isNotEmpty && result[0].rawAddress.length == 4) {
      print('connected');
      final taxiBloc = context.bloc<TaximetroBloc>();
      final destino = context.bloc<MiUbicacionBloc>().state.ubicacion;
      final inicio = context.bloc<TaximetroBloc>().state.inicio;
      // final trafficService = new TrafficService();
      //final traffincResponse =
      //  await trafficService.getCoordsInicioYFin(inicio, destino);
      //final duracion = traffincResponse.routes[0].duration;
      //final distancia = traffincResponse.routes[0].distance;
      final distancia = await calcularDistancia(inicio, destino);
      double duracion = 24000;
      print('====$distancia====');

      taxiBloc
          .add(OnCorreTaximetro(distancia, duracion, destino, parartaximetro));

      print('==== las consultas son: ${contador} ====');
      //    } else {
      //    print('conexion perdina perdida');
      // }
    } on SocketException catch (_) {
      // Estimar precios !!!!
      print('not connected');
    }
  }

  double calcularDistancia(inicio, destino) {
    double distancia = 0;
    const radioTierra = 6378.14;
    final lat = deg2rad(destino.latitude - inicio.latitude);
    final long = deg2rad(destino.longitude - inicio.longitude);
    print('MI lat ===== $lat ====');
    print('MI lon ===== $long ====');
    final a = sin(lat / 2) * sin(lat / 2) +
        cos(deg2rad(inicio.latitude)) *
            cos(deg2rad(destino.latitude)) *
            sin(long / 2) *
            sin(long / 2);
    print('MI AAA ===== $a ====');
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final d = radioTierra * c; // Distance in km
    distancia = d * 1000;
    return distancia;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  void _alertaConfirmacionInicio(BuildContext context, TaximetroState state) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        accion = false;
        iniciaViaje = false;
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () {
        iniciaViaje = true;
        parartaximetro = false;
        accion = true;

        print('===== inicio viaje $accion====');
        Navigator.of(context).pop();

        _iniciarDetenerViaje(context, state);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta de confirmación"),
      content: Text("¿Desea iniciar viaje?"),
      actions: [
        cancelButton,
        continueButton,
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

  void _alertaConfirmacionDetener(BuildContext context, TaximetroState state) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        accion = false;
        Navigator.of(context).pop();
      },
    );
    Widget esperarButton = FlatButton(
      child: Text("Esperar"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () {
        iniciaViaje = false;
        parartaximetro = true;
        accion = true;
        _iniciarDetenerViaje(context, state);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta de confirmación"),
      content: Text("¿Desea detener el  viaje?"),
      actions: [
        cancelButton,
        esperarButton,
        continueButton,
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
