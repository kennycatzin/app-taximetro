part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  const MarcadorManual({Key? key, required this.isLandscape}) : super(key: key);

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final taximetroState = context.read<TaximetroBloc>().state;
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual && !taximetroState.startIsPressed) {
          return _BuildMarcadorManual(isLandscape: isLandscape);
        }
        return Container();
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  const _BuildMarcadorManual({Key? key, required this.isLandscape})
      : super(key: key);

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final buttonWidth = min(width * (isLandscape ? 0.34 : 0.78), 340.0);

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: 12,
            child: FadeInLeft(
              child: Material(
                color: Colors.white.withOpacity(0.96),
                shape: CircleBorder(),
                elevation: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    context
                        .read<BusquedaBloc>()
                        .add(OnDesActivarMarcadorManual());
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0.0, -12.0),
              child: BounceInDown(
                duration: Duration(milliseconds: 850),
                from: 200,
                child: Icon(
                  Icons.location_on,
                  size: 54,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: isLandscape ? 36 : 144,
            child: FadeIn(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: buttonWidth,
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Confirmar destino',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    color: Colors.black,
                    shape: StadiumBorder(),
                    elevation: 4,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      calcularDestino(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final mapaBloc = context.read<MapaBloc>();
    final taxiBloc = context.read<TaximetroBloc>();
    final trafficService = TrafficService();
    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    if (inicio == null || destino == null) {
      Navigator.of(context).pop();
      return;
    }

    final reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino);
    final traffincResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    if (!context.mounted) {
      return;
    }

    if (traffincResponse.routes.isEmpty ||
        reverseQueryResponse.features.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final geometry = traffincResponse.routes[0].geometry;
    final duracion = traffincResponse.routes[0].duration;
    final distancia = traffincResponse.routes[0].distance;
    final nombreDestino = reverseQueryResponse.features[0].placeNameEs;
    final rutaCoords = decodePolyline(geometry, precision: 6);

    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoords, distancia, duracion, nombreDestino));
    taxiBloc.add(OnCotizarPrecio(distancia.toString(), duracion.toString()));
    Navigator.of(context).pop();
    context.read<BusquedaBloc>().add(OnDesActivarMarcadorManual());
  }
}
