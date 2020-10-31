import 'package:flutter/material.dart';
import 'package:mapa_app/models/viajes_response.dart';

class ListaViajes extends StatelessWidget {
  final List<Datum> viajes;

  const ListaViajes(this.viajes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.viajes.length,
      itemBuilder: (BuildContext context, int index) {
        return _Viaje(
          viaje: this.viajes[index],
          index: index,
        );
      },
    );
  }
}

class _Viaje extends StatelessWidget {
  final Datum viaje;
  final int index;

  const _Viaje({@required this.viaje, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TarjetaTopBar(viaje: viaje, index: index),
        // _TarjetaImagen(noticia: noticia),
        _TarjetaTitulo(viaje: viaje),
        _TarjetaBody(viaje: viaje),
        _TarjetaBotones(),
        SizedBox(
          height: 10,
        ),
        Divider()
      ],
    );
  }
}

class _TarjetaTopBar extends StatelessWidget {
  final Datum viaje;
  final int index;

  const _TarjetaTopBar({this.viaje, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            '${index + 1}',
            style: (TextStyle(color: Colors.redAccent)),
          )
        ],
      ),
    );
  }
}

class _TarjetaTitulo extends StatelessWidget {
  final Datum viaje;

  const _TarjetaTitulo({this.viaje});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_money,
              color: Colors.black87,
              size: 30,
            ),
            Text(
              '${viaje.precio.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black87, fontSize: 30),
            )
          ],
        ));
  }
}

// class _TarjetaImagen extends StatelessWidget {
//   final Article noticia;

//   const _TarjetaImagen({this.noticia});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
//         child: Container(
//           child: (noticia.urlToImage != "(none)")
//               ? FadeInImage(
//                   placeholder: AssetImage('assets/img/giphy.gif'),
//                   image: NetworkImage(noticia.urlToImage),
//                 )
//               : Image(
//                   image: AssetImage('assets/img/no-image.png'),
//                 ),
//         ),
//       ),
//     );
//   }
// }

class _TarjetaBody extends StatelessWidget {
  final Datum viaje;

  const _TarjetaBody({this.viaje});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text((viaje.km != null) ? '${viaje.km} KM' : '0 KM'));
  }
}

class _TarjetaBotones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RawMaterialButton(
            child: Icon(Icons.star_border),
            fillColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: null),
        SizedBox(width: 10),
        RawMaterialButton(
            child: Icon(Icons.more),
            fillColor: Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: null),
      ],
    );
  }
}
