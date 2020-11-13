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
  bool enEspera = false;
  int contador = 0;
  DateTime horaActual;
  String accionChofer = "Esperar";
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
    taximetoBloc.add(OnStartIsPressed(inicio, 5.00));

    _cotizar(context, parartaximetro, 10);
    if (state.startIsPressed) {
      print('== Debo ir a la pantalla pago ====');
      await _verificaPrecios(context);
      enEspera = false;
      accionChofer = "Esperar";
      Future.delayed(Duration(milliseconds: 2000)).then((value) => {
            Navigator.pushNamed(context, 'cobro')

            //_mapController.showMarkerInfoWindow(MarkerId('final'))
          });
    }
  }

  double calcularTarifa(TarifaState tarifaState, double km) {
    List<dynamic> objeto;
    List<dynamic> detalle;
    double tarifa = 0;
    var bandera = 0;
    int tomado = 1;

    objeto = tarifaState.horarios;
    DateTime now = DateTime.now();
    var contador = 0;
    // final formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    for (var i = 0; i <= objeto.length - 1; i++) {
      var horaInicial = objeto[i]["hora_inicial"];
      var horaFinal = objeto[i]["hora_final"];
      var arr = horaInicial.split(':');
      var arr2 = horaFinal.split(':');

      if (i > 0) {
        tomado = 1;
      }
      final startTime = DateTime(now.year, now.month, now.day,
          int.parse(arr[0]), int.parse(arr[1]), int.parse(arr[2]));
      final endTime = DateTime(now.year, now.month, now.day + 1,
          int.parse(arr2[0]), int.parse(arr2[1]), int.parse(arr2[2]));

      final currentTime = DateTime.now();

      if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
        print("entrando a la cueva $i");
        detalle = objeto[i]["detalle_horario"];
        for (var j = 0; j <= detalle.length - 1; j++) {
          if (bandera == 0) {
            if (km >= detalle[j]["km_inicial"] &&
                km <= detalle[j]["km_final"]) {
              print("entro en ${detalle[j]["precio"].toDouble()}");
              tarifa = detalle[j]["precio"].toDouble();
              bandera = 1;
            }
          }
        }
      }
    }
    return tarifa;
  }

  void _cotizar(BuildContext context, bool parar, int intervalo_tiempo) async {
    if (!parar) {
      miTimer =
          new Timer.periodic(Duration(seconds: intervalo_tiempo), (timer) {
        print(DateTime.now());
        _verificaPrecios(context);
      });
    } else {
      miTimer.cancel();
    }
  }

  double convertKM(double kilometraje) {
    double kilometros = kilometraje / 1000;
    kilometros = (kilometros * 100).toDouble();
    kilometros = kilometros / 100;
    String totalReal = '';

    totalReal = kilometros.toStringAsFixed(3);

    return double.parse(totalReal);
  }

  void _verificaPrecios(BuildContext context) async {
    try {
      final taxiBloc = context.bloc<TaximetroBloc>();
      final tarifaState = context.bloc<TarifaBloc>().state;

      if (!enEspera) {
        contador++;
        final destino = context.bloc<MiUbicacionBloc>().state.ubicacion;
        final inicio = context.bloc<TaximetroBloc>().state.inicio;
        double distancia = await calcularDistancia(inicio, destino);
        final auxDistancia = await convertKM(distancia);
        final miDistancia = taxiBloc.state.km + auxDistancia;
        final miTarifa = await calcularTarifa(tarifaState, miDistancia);
        print(
            '=== mi distancia === : $auxDistancia ==== mi tarifa ====:::::: $miTarifa');
        double duracion = 24000;
        taxiBloc.add(OnCorreTaximetro(
            distancia,
            duracion,
            destino,
            parartaximetro,
            miTarifa,
            enEspera,
            tarifaState.tarifaMinima,
            tarifaState.tarifaTiempo));
      } else {
        print(
            "=== mi tarifa ${tarifaState.tarifaTiempo}  ==== mi intervalo ${tarifaState.intervaloTiempo}, ==== mi programado ${10.toString()}");
        taxiBloc.add(OnEspera(
            tarifaState.tarifaTiempo, tarifaState.intervaloTiempo, 10));
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  double calcularDistancia(inicio, destino) {
    double distancia = 0;
    const radioTierra = 6378.14;
    final lat = deg2rad(destino.latitude - inicio.latitude);
    final long = deg2rad(destino.longitude - inicio.longitude);
    final a = sin(lat / 2) * sin(lat / 2) +
        cos(deg2rad(inicio.latitude)) *
            cos(deg2rad(destino.latitude)) *
            sin(long / 2) *
            sin(long / 2);
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

  void accionarEsperaOAvanza() {
    if (!enEspera) {
      accionChofer = "Continuar";
      enEspera = true;
    } else {
      accionChofer = "Esperar";
      enEspera = false;
    }
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
      child: Text(accionChofer),
      onPressed: () {
        accionarEsperaOAvanza();
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
