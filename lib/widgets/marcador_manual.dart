part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taximetroState = BlocProvider.of<TaximetroBloc>(context).state;
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual && !taximetroState.startIsPressed) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widht = MediaQuery.of(context).size.width;

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
                  //  hacer algo chidori
                  BlocProvider.of<BusquedaBloc>(context)
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
                size: 50,
              ),
            ),
          ),
        ),
        // Boton confirmar destino
        Positioned(
          bottom: 70,
          left: widht * .37,
          child: FadeIn(
            child: MaterialButton(
              minWidth: widht - 500,
              child: Text(
                'Confirmar destino',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () {
                this.calcularDestino(context);
              },
            ),
          ),
        )
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
    final trafficService = new TrafficService();
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    // Obtener informacion del destino
    final reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino);

    final traffincResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    final geometry = traffincResponse.routes[0].geometry;
    final duracion = traffincResponse.routes[0].duration;
    final distancia = traffincResponse.routes[0].distance;
    final nombreDestino = reverseQueryResponse.features[0].placeNameEs;
    // Decodificar los puntos del geometry

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> rutaCoords =
        points.map((point) => LatLng(point[0], point[1])).toList();

    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoords, distancia, duracion, nombreDestino));
    taxiBloc.add(OnCotizarPrecio(distancia.toString(), duracion.toString()));
    Navigator.of(context).pop();
    BlocProvider.of<BusquedaBloc>(context).add(OnDesActivarMarcadorManual());

    // tarea quitar el confirmar destino, marcador y el boton para regresar
  }
}
