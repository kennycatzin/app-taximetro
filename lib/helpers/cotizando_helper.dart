part of 'helpers.dart';

class CotizandoHelper {
  double kilometraje;
  double tiempo;
  CotizandoHelper({this.kilometraje, this.tiempo});

  double calculaPrecio() {
    double kilometros = kilometraje / 1000;
    double totalViaje = (kilometros * 9.5).toDouble();

    return totalViaje.roundToDouble();
  }

  double calculaDistancia() {
    double kilometros = kilometraje / 1000;
    kilometros = (kilometros * 100).toDouble();
    kilometros = kilometros / 100;
    String totalReal = '';

    totalReal = kilometros.toStringAsFixed(3);

    return double.parse(totalReal);
  }

  double calculaTiempoEnMinutos() {
    double minutos = this.tiempo / 60;

    return minutos;
  }
}
