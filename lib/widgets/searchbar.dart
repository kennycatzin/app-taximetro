part of 'widgets.dart';

class DestinationSearchBar extends StatelessWidget {
  const DestinationSearchBar({Key? key, required this.isLandscape})
      : super(key: key);

  final bool isLandscape;

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
    final maxWidth = min(width - 24, isLandscape ? 520.0 : width);

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Center(
          child: SizedBox(
            width: maxWidth,
            child: GestureDetector(
              onTap: () async {
                final proximidad =
                    context.read<MiUbicacionBloc>().state.ubicacion;
                if (proximidad == null) {
                  return;
                }
                final historial = context.read<BusquedaBloc>().state.historial;
                final resultado = await showSearch(
                    context: context,
                    delegate: SearchDestination(proximidad, historial));

                if (!context.mounted) {
                  return;
                }

                if (resultado != null) {
                  retornoBusquea(context, resultado);
                }
              },
              child: Container(
                height: 54,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '¿Dónde quieres ir?',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.black38),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6))
                    ]),
              ),
            ),
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

    if (!context.mounted) {
      return;
    }

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
