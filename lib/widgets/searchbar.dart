part of 'widgets.dart';

class DestinationSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        }
        return FadeInDownBig(child: buildSearchBar(context));
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: width * .6,
        child: GestureDetector(
          onTap: () async {
            final proximidad = context.read<MiUbicacionBloc>().state.ubicacion;
            if (proximidad == null) {
              return;
            }
            final historial = context.read<BusquedaBloc>().state.historial;
            final resultado = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad, historial));

            if (resultado != null) {
              retornoBusquea(context, resultado);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            width: width * .5,
            height: 40,
            child: Text(
              '¿Dónde quieres ir?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
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
    if (result.cancelo) {
      return;
    }
    if (result.manual) {
      context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);
    final trafficService = TrafficService();
    final mapaBloc = context.read<MapaBloc>();
    final taxiBloc = context.read<TaximetroBloc>();
    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;

    if (inicio == null || destino == null) {
      Navigator.of(context).pop();
      return;
    }

    final drivingResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    if (drivingResponse.routes.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final nombreDestino = result.nombreDestino;
    final rutaCoordenadas = decodePolyline(geometry, precision: 6);

    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoordenadas, distancia, duracion, nombreDestino));
    taxiBloc.add(OnCotizarPrecio(distancia.toString(), duracion.toString()));

    Navigator.of(context).pop();
    context.read<BusquedaBloc>().add(OnAgregarHistorial(result));
  }
}
