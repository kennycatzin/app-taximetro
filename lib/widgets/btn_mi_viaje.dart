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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    miTimer.cancel();
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
                print('===== inicio viaje $accion====');
                _iniciarDetenerViaje(context, state);
              } else {
                return;
              }
            } else {
              _alertaConfirmacionDetener(context, state);
              // if (accion) {
              //   print('=== aqui no deberia entrar ===');
              //   _iniciarDetenerViaje(context, state);
              // }
            }
          },
          color: Colors.redAccent,
          textColor: Colors.white,
          child: Icon(
            state.startIsPressed ? Icons.pause : Icons.play_arrow,
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

    if (!state.startIsPressed) {
      busquedaBloc.add(OnActivarMarcadorManual());
      mapaBloc.add(OnCrearMarcadorInicio(inicio));
      mapaBloc.add(OnSeguirUbicacion());
      mapaBloc.add(OnMarcarRecorrido());
      parartaximetro = false;
    } else {
      busquedaBloc.add(OnDesActivarMarcadorManual());
      mapaBloc.add(OnCrearMarcadorFinal(inicio));
      parartaximetro = true;
    }
    _cotizar(context, parartaximetro);
    taximetoBloc.add(OnStartIsPressed(inicio));
    if (state.startIsPressed) {
      print('== Debo ir a la pantalla pago ====');
      await _verificaPrecios(context);
      Navigator.pushNamed(context, 'cobro');
    }
  }

  void _cotizar(BuildContext context, bool parar) async {
    if (!parar) {
      miTimer = new Timer.periodic(const Duration(seconds: 90), (timer) {
        print(DateTime.now());
        _verificaPrecios(context);
      });
    } else {
      miTimer.cancel();
    }
  }

  void _verificaPrecios(BuildContext context) async {
    final taxiBloc = context.bloc<TaximetroBloc>();
    final destino = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final inicio = context.bloc<TaximetroBloc>().state.inicio;
    final trafficService = new TrafficService();
    final traffincResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);
    final duracion = traffincResponse.routes[0].duration;
    final distancia = traffincResponse.routes[0].distance;
    taxiBloc.add(OnCorreTaximetro(distancia, duracion, destino));
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
