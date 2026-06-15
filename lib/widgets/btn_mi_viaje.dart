part of 'widgets.dart';

class BtnMiViaje extends StatefulWidget {
  const BtnMiViaje({Key? key, required this.isLandscape}) : super(key: key);

  final bool isLandscape;

  @override
  _BtnMiViajeState createState() => _BtnMiViajeState();
}

class _BtnMiViajeState extends State<BtnMiViaje> {
  static const double _dragThreshold = 0.82;

  Timer? miTimer;
  Timer? _finalizarViajeTimer;
  bool parartaximetro = true;
  bool iniciaViaje = false;
  bool accion = false;
  bool enEspera = false;
  bool viajeFinalizado = false;
  int contador = 0;
  DateTime? horaActual;
  String accionChofer = "Esperar";
  String cabeceraChofer = "¿Cobrar tiempo de espera?";
  double? _dragProgress;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaximetroBloc, TaximetroState>(
        builder: (context, state) => _btnIniciar(context, state));
  }

  Widget _btnIniciar(BuildContext context, TaximetroState state) {
    final logicalProgress = state.startIsPressed ? 1.0 : 0.0;
    final trackHeight = widget.isLandscape ? 52.0 : 54.0;
    final thumbSize = widget.isLandscape ? 42.0 : 42.0;
    final accentColor = state.startIsPressed
        ? (enEspera ? Colors.green : Colors.blueGrey.shade900)
        : Colors.redAccent;
    final title = state.startIsPressed ? 'Viaje activo' : 'Iniciar viaje';
    final subtitle = state.startIsPressed
        ? (widget.isLandscape
            ? 'Desliza para opciones'
            : 'Desliza a la izquierda para opciones')
        : (widget.isLandscape
            ? 'Desliza para comenzar'
            : 'Desliza a la derecha para comenzar');

    return Opacity(
      opacity: viajeFinalizado ? 0.65 : 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width - 32;
          final travelWidth = max(0.0, width - thumbSize - 12);
          final currentProgress = _isDragging
              ? (_dragProgress ?? logicalProgress)
              : logicalProgress;
          final thumbLeft = 6 + (travelWidth * currentProgress);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: viajeFinalizado
                ? null
                : (_) {
                    setState(() {
                      _isDragging = true;
                      _dragProgress = logicalProgress;
                    });
                  },
            onHorizontalDragUpdate: viajeFinalizado
                ? null
                : (details) {
                    if (travelWidth == 0) {
                      return;
                    }
                    setState(() {
                      _dragProgress = ((_dragProgress ?? logicalProgress) +
                              (details.primaryDelta ?? 0) / travelWidth)
                          .clamp(0.0, 1.0);
                    });
                  },
            onHorizontalDragEnd: viajeFinalizado
                ? null
                : (_) {
                    final progress = _dragProgress ?? logicalProgress;
                    final shouldTrigger = !state.startIsPressed
                        ? progress >= _dragThreshold
                        : progress <= (1 - _dragThreshold);

                    setState(() {
                      _isDragging = false;
                      _dragProgress = null;
                    });

                    if (shouldTrigger) {
                      accionBoton(state);
                    }
                  },
            child: Material(
              color: Colors.white.withOpacity(0.95),
              elevation: 18,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(trackHeight / 2),
              child: SizedBox(
                width: double.infinity,
                height: trackHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 220),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(trackHeight / 2),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              accentColor.withOpacity(0.90),
                              accentColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: state.startIsPressed ? 20 : thumbSize + 22,
                          right: state.startIsPressed ? thumbSize + 22 : 20,
                        ),
                        child: Row(
                          children: [
                            if (state.startIsPressed) ...[
                              Icon(Icons.chevron_left_rounded,
                                  color: Colors.white70),
                              SizedBox(width: 2),
                              Icon(Icons.chevron_left_rounded,
                                  color: Colors.white54),
                            ],
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: state.startIsPressed
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.isLandscape ? 15 : 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: widget.isLandscape ? 10 : 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!state.startIsPressed) ...[
                              Icon(Icons.chevron_right_rounded,
                                  color: Colors.white70),
                              SizedBox(width: 2),
                              Icon(Icons.chevron_right_rounded,
                                  color: Colors.white54),
                            ],
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: _isDragging ? 0 : 220),
                      curve: Curves.easeOut,
                      left: thumbLeft,
                      top: 6,
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          state.startIsPressed
                              ? (!enEspera ? Icons.pause : Icons.timer)
                              : Icons.play_arrow,
                          size: widget.isLandscape ? 24 : 22,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void accionBoton(TaximetroState state) {
    final miUsuario = BlocProvider.of<UsuarioBloc>(context);
    if (!miUsuario.state.conectado) {
      return;
    }
    if (parartaximetro) {
      _alertaConfirmacionInicio(context, state);
      if (accion) {
        _iniciarDetenerViaje(context, state);
      }
    } else {
      _alertaConfirmacionDetener(context, state);
    }
  }

  void _iniciarDetenerViaje(BuildContext context, TaximetroState state) async {
    final taximetoBloc = BlocProvider.of<TaximetroBloc>(context);
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final miTarifa = BlocProvider.of<TarifaBloc>(context).state;
    final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    if (inicio == null) {
      return;
    }

    final hora = DateTime.now();
    final horaReal = '${hora.hour}:${hora.minute}:${hora.second}';
    mapaBloc.add(OnSeguirUbicacion());

    if (!state.startIsPressed) {
      busquedaBloc.add(OnActivarMarcadorManual());
      mapaBloc.add(OnCrearMarcadorInicio(inicio));
      mapaBloc.add(OnQuitarPoliline());
      mapaBloc.add(OnMarcarRecorrido());
      taximetoBloc.add(OnHoraInicio(horaReal));
      parartaximetro = false;
    } else {
      viajeFinalizado = true;
      busquedaBloc.add(OnDesActivarMarcadorManual());
      mapaBloc.add(OnCrearMarcadorFinal(inicio));
      mapaBloc.add(OnQuitarMarcadores());
      taximetoBloc.add(OnHoraFinal(horaReal));
      mapaBloc.add(OnMarcarRecorrido());
      parartaximetro = true;
    }
    taximetoBloc.add(OnStartIsPressed(inicio, miTarifa.banderazo));

    _cotizar(context, parartaximetro, 10);
    if (state.startIsPressed) {
      _verificaPrecios(context);
      enEspera = false;
      accionChofer = "Esperar";
      cabeceraChofer = "¿Cobrar tiempo de espera?";
      _finalizarViajeTimer?.cancel();
      _finalizarViajeTimer = Timer(Duration(milliseconds: 2000), () {
        if (!mounted) {
          return;
        }

        miUbicacionBloc.cancelarSeguimiento();
        Navigator.pushReplacementNamed(context, 'cobro');
      });
    }
  }

  double calcularTarifa(TarifaState tarifaState, double km) {
    List<dynamic> objeto;
    List<dynamic> detalle;
    double tarifa = 0;
    var bandera = 0;
    var tomado = 1;

    objeto = tarifaState.horarios;
    final now = DateTime.now();
    for (var i = 0; i <= objeto.length - 1; i++) {
      final horaInicial = objeto[i]["hora_inicial"];
      final horaFinal = objeto[i]["hora_final"];
      final arr = horaInicial.split(':');
      final arr2 = horaFinal.split(':');

      if (i > 0) {
        tomado = 1;
      }
      final startTime = DateTime(now.year, now.month, now.day,
          int.parse(arr[0]), int.parse(arr[1]), int.parse(arr[2]));
      final endTime = DateTime(now.year, now.month, now.day + tomado,
          int.parse(arr2[0]), int.parse(arr2[1]), int.parse(arr2[2]));

      final currentTime = DateTime.now();

      if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
        detalle = objeto[i]["detalle_horario"];
        for (var j = 0; j <= detalle.length - 1; j++) {
          if (bandera == 0) {
            if (km >= detalle[j]["km_inicial"] &&
                km <= detalle[j]["km_final"]) {
              tarifa = detalle[j]["precio"].toDouble();
              bandera = 1;
            }
          }
        }
      }
    }
    return tarifa;
  }

  void _cotizar(BuildContext context, bool parar, int intervaloTiempo) async {
    if (!parar) {
      miTimer = Timer.periodic(Duration(seconds: intervaloTiempo), (timer) {
        _verificaPrecios(context);
      });
    } else {
      miTimer?.cancel();
    }
  }

  double convertKM(double kilometraje) {
    double kilometros = kilometraje / 1000;
    kilometros = (kilometros * 100).toDouble();
    kilometros = kilometros / 100;
    final totalReal = kilometros.toStringAsFixed(3);
    return double.parse(totalReal);
  }

  void _verificaPrecios(BuildContext context) async {
    try {
      final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
      final tarifaState = BlocProvider.of<TarifaBloc>(context).state;
      final destino = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
      final inicio = BlocProvider.of<TaximetroBloc>(context).state.inicio;
      if (inicio == null || destino == null) {
        return;
      }

      if (!enEspera) {
        contador++;
        final distancia = calcularDistancia(inicio, destino);
        final auxDistancia = convertKM(distancia);
        final miDistancia = taxiBloc.state.km + auxDistancia;
        final miTarifa = calcularTarifa(tarifaState, miDistancia);

        const duracion = 24000.0;
        taxiBloc.add(OnCorreTaximetro(
            distancia,
            duracion,
            destino,
            parartaximetro,
            miTarifa,
            enEspera,
            tarifaState.tarifaMinima,
            tarifaState.tarifaTiempo,
            tarifaState.banderazo));
      } else {
        taxiBloc.add(OnEspera(
            tarifaState.tarifaTiempo,
            tarifaState.intervaloTiempo,
            10,
            parartaximetro,
            tarifaState.tarifaMinima,
            tarifaState.banderazo));
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
    final d = radioTierra * c;
    distancia = d * 1000;
    return distancia;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  void _alertaConfirmacionInicio(BuildContext context, TaximetroState state) {
    Widget cancelButton = ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.redAccent),
      ),
      label: Text('No'),
      icon: Icon(Icons.cancel),
      onPressed: () {
        accion = false;
        iniciaViaje = false;
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      label: Text('Si'),
      icon: Icon(Icons.check_circle),
      onPressed: () {
        iniciaViaje = true;
        parartaximetro = false;
        accion = true;
        Navigator.of(context).pop();
        _iniciarDetenerViaje(context, state);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Center(child: Text("¿Desea iniciar viaje?")),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void accionarEsperaOAvanza() {
    if (!enEspera) {
      accionChofer = "Si";
      cabeceraChofer = "¿Continuar con el viaje?";
      enEspera = true;
    } else {
      accionChofer = "Si";
      cabeceraChofer = "¿Cobrar tiempo de espera?";
      enEspera = false;
    }
  }

  void _alertaConfirmacionDetener(BuildContext context, TaximetroState state) {
    Widget cancelButton = ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      label: Text('No'),
      icon: Icon(Icons.cancel),
      onPressed: () {
        accion = false;
        Navigator.of(context).pop();
      },
    );

    Widget esperarButton = ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      label: Text(accionChofer),
      icon: Icon((!enEspera) ? Icons.timer : Icons.time_to_leave),
      onPressed: () {
        _verificaPrecios(context);
        accionarEsperaOAvanza();
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      label: Text("Finalizar viaje"),
      icon: Icon(Icons.payments_sharp),
      onPressed: () {
        iniciaViaje = false;
        parartaximetro = true;
        accion = true;
        _iniciarDetenerViaje(context, state);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(cabeceraChofer),
      actions: [esperarButton, cancelButton, continueButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    miTimer?.cancel();
    _finalizarViajeTimer?.cancel();
    super.dispose();
  }
}
