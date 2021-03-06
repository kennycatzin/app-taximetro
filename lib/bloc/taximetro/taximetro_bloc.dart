import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'taximetro_event.dart';
part 'taximetro_state.dart';

class TaximetroBloc extends Bloc<TaximetroEvent, TaximetroState> {
  TaximetroBloc() : super(TaximetroState());
  int contador = 1;
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
  String stoptimetoDisplay = "00:00:00";
  String pagoInicio = '5.00';
  String kmDis = '0 km';
  final pago = 0;
  final km = '';

  void startTimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    if (swatch.isRunning) {
      startTimer();

      var sec = swatch.elapsed.inSeconds;
      var min = swatch.elapsed.inMinutes;
      var hora = swatch.elapsed.inHours;

      var total = (sec / 60) + min + (hora * 60);
      print("entro $sec");
      if ((sec / contador) == 30) {
        print("aqui consulta los precios ");
        contador++;
      }
      stoptimetoDisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    }
  }

  void stopstopwatch() {
    swatch.stop();
    var sec = swatch.elapsed.inSeconds;
    var min = swatch.elapsed.inMinutes;
    var hora = swatch.elapsed.inHours;

    var total = (sec / 60) + min + (hora * 60);
    print(swatch.elapsed.inMinutes);
    print(swatch.elapsed.inSeconds);
    print(swatch.elapsed.inHours);

    print(total);
  }

  @override
  Stream<TaximetroState> mapEventToState(TaximetroEvent event) async* {
    if (event is OnStartIsPressed) {
      yield* this._onStartIsPressed(event);
    } else if (event is OnCotizarPrecio) {
      yield* this._onCotizarPrecio(event);
    } else if (event is OnCorreTaximetro) {
      yield* this._onCorreTaximetro(event);
    }
  }

  Stream<TaximetroState> _onStartIsPressed(OnStartIsPressed event) async* {
    print('inicia cronometro');
    if (!state.startIsPressed) {
      // swatch.start();
      // startTimer();
    } else {
      // swatch.reset();
      // stopstopwatch();
    }
    print(event.centroMapa);
    print(state.stoptimetoDisplay);
    // if (state.startIsPressed) {
    //   swatch.reset();
    //   stoptimetoDisplay = "00:00:00";
    // }

    yield state.copyWith(
        startIsPressed: !state.startIsPressed,
        stoptimetoDisplay: stoptimetoDisplay,
        inicio: event.centroMapa,
        pago: double.parse(pagoInicio));
  }

  Stream<TaximetroState> _onCotizarPrecio(OnCotizarPrecio event) async* {
    final minutos = (double.parse(event.duracion) / 60).floor();
    double kilometros = double.parse(event.km) / 1000;
    double totalViaje = (kilometros * 9.5).toDouble();
    String totalReal = '';
    if (totalViaje < 25) {
      totalViaje = 25.00;
    }
    totalReal = totalViaje.toStringAsFixed(1);
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    yield state.copyWith(
        km: kilometros,
        stoptimetoDisplay: '$minutos minutos',
        pago: double.parse(totalReal));
  }

  Stream<TaximetroState> _onCorreTaximetro(OnCorreTaximetro event) async* {
    final minutos = (event.duracion / 60).floor();
    double kilometros = event.km / 1000;
    double totalViaje = state.pago + (kilometros * 9.5).toDouble();
    print(totalViaje);
    String totalReal = '';
    // if (totalViaje < 25) {
    //   totalViaje = 25.00;
    // }
    totalReal = totalViaje.toStringAsFixed(1);
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    yield state.copyWith(
        km: state.km + kilometros,
        stoptimetoDisplay: '$minutos minutos',
        pago: double.parse(totalReal),
        inicio: event.inicio);
  }
}
