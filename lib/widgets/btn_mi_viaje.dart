part of 'widgets.dart';

class BtnMiViaje extends StatelessWidget {
  const BtnMiViaje({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaximetroBloc, TaximetroState>(
      builder: (context, state) => _crearBoton(context, state),
    );
  }

  Widget _crearBoton(BuildContext context, TaximetroState state) {
    final size = MediaQuery.of(context).size;
    final taximetoBloc = context.bloc<TaximetroBloc>();
    final busquedaBloc = context.bloc<BusquedaBloc>();
    final mapaBloc = context.bloc<MapaBloc>();
    bool parartaximetro = false;
    Timer timer;

    return Container(
        margin:
            EdgeInsets.only(top: size.width * 0.39, left: size.height * .17),
        child: MaterialButton(
          onPressed: () {
            final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;

            if (!state.startIsPressed) {
              busquedaBloc.add(OnActivarMarcadorManual());
              mapaBloc.add(OnCrearMarcadorInicio(inicio));
              mapaBloc.add(OnSeguirUbicacion());
              mapaBloc.add(OnMarcarRecorrido());
            } else {
              busquedaBloc.add(OnDesActivarMarcadorManual());
              mapaBloc.add(OnCrearMarcadorFinal(inicio));
              parartaximetro = true;

              // mapaBloc.add(OnQuitarPoliline());
            }
            _cotizar(context, timer, parartaximetro);

            taximetoBloc.add(OnStartIsPressed(inicio));
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

  void _cotizar(BuildContext context, Timer timer, bool parar) async {
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (!parar) {
        print(parar);
        print(DateTime.now());
        print("cotizo bro ");
        _verificaPrecios(context);
      } else {
        timer.cancel();
      }
    });
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
}
