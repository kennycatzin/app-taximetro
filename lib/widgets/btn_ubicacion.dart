part of 'widgets.dart';

class BtnUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapaBloc = context.read<MapaBloc>();
    final miUbicacionBloc = context.read<MiUbicacionBloc>();

    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: CircleBorder(),
      child: IconButton(
        tooltip: 'Mi ubicación',
        padding: EdgeInsets.all(14),
        icon: Icon(Icons.my_location, color: Colors.black87),
        onPressed: () {
          final destino = miUbicacionBloc.state.ubicacion;
          if (destino != null) {
            mapaBloc.moverCamara(destino);
          }
        },
      ),
    );
  }
}
