part of 'widgets.dart';

class BtnUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapaBloc = context.bloc<MapaBloc>();
    final miUbicacionBloc = context.bloc<MiUbicacionBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          // icon: Icon(Icons.message, color: Colors.black87),
          icon: new Stack(children: <Widget>[
            new Icon(Icons.message, color: Colors.black87),
            new Positioned(
              // draw a red marble
              top: 0.0,
              right: 0.0,
              child: new Icon(Icons.brightness_1,
                  size: 10.0, color: Colors.redAccent),
            )
          ]),
          onPressed: () {
            Navigator.pushNamed(context, 'mensajes');

            // final destino = miUbicacionBloc.state.ubicacion;
            // mapaBloc.moverCamara(destino);
          },
        ),
      ),
    );
  }
}
