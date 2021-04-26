part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    // : implement build
    return Container(
      margin: EdgeInsets.only(top: 34.0),
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: 150,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(Icons.menu, color: Colors.redAccent),
          onPressed: () {
            // mapaBloc.add( OnMarcarRecorrido() );
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );

    //BlocBuilder<BusquedaBloc, BusquedaState>(
    //   builder: (context, state) {
    //     if (state.seleccionManual) {
    //       return Container();
    //     } else {
    //       return FadeInDownBig(child: buildSearchBar(context));
    //     }
    //   },
    // );
  }

  Widget buildSearchBar(BuildContext context) {
    final wifht = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: wifht * .6,
        child: GestureDetector(
          onTap: () async {
            final proximidad = context.bloc<MiUbicacionBloc>().state.ubicacion;
            final historial = context.bloc<BusquedaBloc>().state.historial;
            final resultado = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad, historial));

            this.retornoBusquea(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            width: wifht * .5,
            height: 40,
            child: Text(
              '¿Dónde quieres ir?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  100,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
          ),
        ),
      ),
    );
  }

  void retornoBusquea(BuildContext context, SearchResult result) async {
    print(result.cancelo);
    print(result.manual);
    if (result.cancelo) {
      return;
    }
    if (result.manual) {
      context.bloc<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }
    calculandoAlerta(context);
    // Calcular la ruta en base al valor
    final trafficService = new TrafficService();
    final mapaBloc = context.bloc<MapaBloc>();
    final taxiBloc = context.bloc<TaximetroBloc>();
    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;

    final drivingResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();

    // TO DO

    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoordenadas, distancia, duracion, nombreDestino));
    taxiBloc.add(OnCotizarPrecio(distancia.toString(), duracion.toString()));

    Navigator.of(context).pop();
    // agregar al historial
    final busquedaBloc = context.bloc<BusquedaBloc>();
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
