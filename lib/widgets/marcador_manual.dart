part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taximetroState = context.read<TaximetroBloc>().state;
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual && !taximetroState.startIsPressed) {
          return _BuildMarcadorManual();
        }
        return Container();
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  context.read<BusquedaBloc>().add(OnDesActivarMarcadorManual());
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
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: width * .37,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 500,
              child: Text(
                'Confirmar destino',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                calcularDestino(context);
              },
            ),
          ),
        )
      ],
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

    mapaBloc.add(
        OnCrearRutaInicioDestino(rutaCoords, distancia, duracion, nombreDestino));
    taxiBloc.add(OnCotizarPrecio(distancia.toString(), duracion.toString()));
    Navigator.of(context).pop();
    context.read<BusquedaBloc>().add(OnDesActivarMarcadorManual());
  }
}
