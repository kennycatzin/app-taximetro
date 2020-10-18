part of 'helpers.dart';

class CotizandoHelper {
  double kilometraje;
  double tiempo;
  CotizandoHelper({this.kilometraje, this.tiempo});

  String calculaPrecio() {
    double kilometros = kilometraje / 1000;
    double totalViaje = (kilometros * 9.5).toDouble();
    String totalReal = '';

    totalReal = totalViaje.toStringAsFixed(1);

    return totalReal;
  }

  double calculaDistancia() {
    double kilometros = this.kilometraje / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    return kilometros;
  }

  double calculaTiempoEnMinutos() {
    double minutos = this.tiempo / 60;

    return minutos;
  }
}
