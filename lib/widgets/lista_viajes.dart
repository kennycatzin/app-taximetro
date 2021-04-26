import 'package:flutter/material.dart';
import 'package:mapa_app/models/viajes_response.dart';

class ListaViajes extends StatelessWidget {
  final List<Datum> viajes;

  const ListaViajes(this.viajes);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: this.viajes.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            children: [
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black87,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(2),
                    width: size.width * .45,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                        Text(
                          " ${sumaTotales(this.viajes).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black87,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(2),
                    width: size.width * .45,
                    height: 100,
                    child: Text("KM: ${sumaKm(this.viajes).toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              _Viaje(
                viaje: this.viajes[index],
                index: index,
              )
            ],
          );
        }
        return _Viaje(
          viaje: this.viajes[index],
          index: index,
        );
      },
    );
  }
}

double sumaTotales(List<Datum> viajes) {
  double suma = 0;

  viajes.forEach((element) {
    suma = suma + element.precio;
  });
  return suma;
}

double sumaKm(List<Datum> viajes) {
  double suma = 0;

  viajes.forEach((element) {
    suma = suma + element.km;
  });
  return suma;
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
        _TarjetaBotones(viaje: viaje),
        _TarjetaHora(
          viaje: viaje,
        ),
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

class _TarjetaTotales extends StatelessWidget {
  final Datum viaje;

  const _TarjetaTotales({this.viaje});
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
              '90',
              style: TextStyle(color: Colors.black87, fontSize: 30),
            )
          ],
        ));
  }
}

class _TarjetaBody extends StatelessWidget {
  final Datum viaje;

  const _TarjetaBody({this.viaje});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          (viaje.km != null) ? '${viaje.km} KM' : '0 KM',
          style: TextStyle(fontSize: 19),
        ));
  }
}

class _TarjetaHora extends StatelessWidget {
  final Datum viaje;

  const _TarjetaHora({this.viaje});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text((viaje.horaInicio != null)
                ? 'Hora inicio:  ${viaje.horaInicio}'
                : '--.--.--')),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text((viaje.horaTermino != null)
                ? 'Hora término:  ${viaje.horaTermino}'
                : '--.--.--'))
      ],
    );
  }
}

class _TarjetaBotones extends StatelessWidget {
  final Datum viaje;

  const _TarjetaBotones({this.viaje});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        (this.viaje.tipo_viaje == 1)
            ? RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.redAccent,
                textColor: Colors.white,
                label: Text('Efectivo'),
                icon: Icon(Icons.money),
                onPressed: () => {})
            : (this.viaje.tipo_viaje == 2)
                ? RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    label: Text('Tarjeta'),
                    icon: Icon(Icons.card_membership_outlined),
                    onPressed: () => {},
                  )
                : null
      ],
    );
  }
}
