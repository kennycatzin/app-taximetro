import 'package:flutter/material.dart';
import 'package:mapa_app/custom_markers.dart/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: 350,
        height: 150,
        color: Colors.red,
        child: CustomPaint(
          //painter: MarkerInicioPainter(250),
          painter: MarkerDestinoPainter(
              'Mi direccion en la benito juarez oriente ahora', 25000),
        ),
      )),
    );
  }
}
