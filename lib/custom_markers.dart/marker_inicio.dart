part of 'custom_markers.dart';

class MarkerInicioPainter extends CustomPainter {
  final int minutos;
  final double metros;
  MarkerInicioPainter(this.minutos, this.metros);
  @override
  void paint(Canvas canvas, Size size) {
    final double circuloNegroR = 20;
    final double circuloBlancoR = 7;

    Paint paint = new Paint()..color = Colors.black;

    // Dibujar circulo negro

    canvas.drawCircle(
        Offset(circuloNegroR, size.height - circuloNegroR), 20, paint);

    //Dibujar circulo blanco

    paint.color = Colors.white;
    canvas.drawCircle(Offset(circuloNegroR, size.height - circuloNegroR),
        circuloBlancoR, paint);

    final Path path = new Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);
    // caja blanca
    final cajablanca = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(cajablanca, paint);

    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar textos
    TextSpan textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: '${this.minutos}');

    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 35));

//Minutos
    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Min');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 67));

    // Mi ubicacion
    double kilometros = this.metros / 1000;

    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;
    double totalViaje = (kilometros * 9.5).toDouble();
    String totalReal = '';
    if (totalViaje < 25) {
      totalViaje = 25.00;
    }
    totalReal = totalViaje.toStringAsFixed(1);
    textSpan = new TextSpan(
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        text: 'Total del viaje: ${totalReal}');

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: size.width - 130);

    textPainter.paint(canvas, Offset(120, 47));
  }

  @override
  bool shouldRepaint(MarkerInicioPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerInicioPainter oldDelegate) => false;
}
