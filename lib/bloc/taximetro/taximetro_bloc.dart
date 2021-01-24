import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/helpers/helpers.dart';
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
  List<Map<String, double>> _puntosRuta = [];

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
    } else if (event is OnIniciarValores) {
      yield* this._onIniciarValores(event);
    } else if (event is OnHoraInicio) {
      yield state.copyWith(horaInicio: event.hora);
    } else if (event is OnHoraFinal) {
      yield state.copyWith(horaFinal: event.hora);
    } else if (event is OnEspera) {
      yield* this._onEspera(event);
    }
  }

  Stream<TaximetroState> _onStartIsPressed(OnStartIsPressed event) async* {
    print('inicia cronometro');
    if (!state.startIsPressed) {
      // swatch.start();
      // startTimer();
      yield state.copyWith(
          startIsPressed: !state.startIsPressed,
          stoptimetoDisplay: stoptimetoDisplay,
          inicio: event.centroMapa,
          pago: event.banderazo,
          tiempoCobroMeta: 0.0,
          metaTiempo: -10,
          metaCobro: 0.0,
          cobraTiempo: false,
          metaDistancia: 0.0,
          pagoTiempo: 0.0);
      this._puntosRuta = [];
    } else {
      print('=== para viajesin! ===');
      yield state.copyWith(
        startIsPressed: !state.startIsPressed,
      );
    }
    print(event.centroMapa);
    print(state.stoptimetoDisplay);
  }

  Stream<TaximetroState> _onIniciarValores(OnIniciarValores event) async* {
    yield state.copyWith(km: 0.0, stoptimetoDisplay: '00:00:00', pago: 0.0);
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

  Stream<TaximetroState> _onEspera(OnEspera event) async* {
    double pago;
    pago = (event.prograInter * event.tarifaTiempo) / event.intervalo;
    pago = double.parse(pago.toStringAsFixed(2));
    print(state.tiempoCobroMeta);

    if (state.cobraTiempo) {
      // despues de bandera para hacer el cambio cada 5 segundos
      print("despues de bandera para hacer el cambio cada 5 segundos");

      yield state.copyWith(
          pagoTiempo: state.pagoTiempo + pago,
          tiempoCobroMeta: state.tiempoCobroMeta + pago);
    } else {
      yield state.copyWith(metaTiempo: state.metaTiempo + event.prograInter);
      if (state.metaTiempo >= 180) {
        // despues de cumplir los segundos se da bandera de cobrar normal
        print("despues de cumplir los segundos se da bandera de cobrar normal");
        // realiza la suma
        yield state.copyWith(
            pagoTiempo: state.pagoTiempo + pago + state.metaCobro,
            cobraTiempo: true,
            tiempoCobroMeta: state.tiempoCobroMeta + pago);
      } else {
        // antes del cobro
        yield state.copyWith(
            metaTiempo: state.metaTiempo + event.prograInter,
            metaCobro: state.metaCobro + pago,
            tiempoCobroMeta: state.tiempoCobroMeta + pago);
        print(state.metaTiempo);
        print(state.metaCobro);
      }
    }
    if (event.finaliza) {
      double miTotal = state.tiempoCobroMeta + 5;
      print("Mi total es: =====" + miTotal.toString());
      print("=== mi tiempo de cobro es ${state.tiempoCobroMeta}");
      // no se le ha sumado
      double totalParcial = await this.calculaPrecioFinal(event.banderazo);
      if (totalParcial < event.tarifaMinima) {
        // Calcula el total mínimo
        miTotal = event.tarifaMinima + state.pagoTiempo;
        pago = miTotal;
      } else {
        print("==== valgo masss ===");
        pago = totalParcial + state.pagoTiempo;
      }
      yield state.copyWith(
        pago: pago,
      );
    }
  }

  Stream<TaximetroState> _onCorreTaximetro(OnCorreTaximetro event) async* {
    CotizandoHelper cotizaController = new CotizandoHelper(
        kilometraje: event.km, tiempo: event.duracion, tarifa: event.tarifa);
    double minutos;
    double kilometros = 0;
    double pagoReal = state.pago;
    double tarifaTiempo = 0;
    double totalViaje = 0;

    if (!event.enEspera) {
      minutos = cotizaController.calculaTiempoEnMinutos();
      kilometros = cotizaController.calculaDistancia();
      totalViaje = cotizaController.calculaPrecio();
      print("mi principio es :: ======== ${state.pago}");
      print("mi total de km  es :: ======== ${totalViaje}");

      pagoReal = pagoReal + totalViaje;
    }
    print("mis km ====== $kilometros");
    Map<String, double> newPunto = {
      "tarifa": event.tarifa,
      "distancia": kilometros
    };
    _puntosRuta.insert(0, newPunto);
    print(_puntosRuta.length);

    if (event.estado) {
      pagoReal = await this.calculaPrecioFinal(event.banderazo);
      if (pagoReal < event.tarifaMinima) {
        pagoReal = event.tarifaMinima.toDouble();
      }
      pagoReal = pagoReal + state.pagoTiempo;
      // TODO recalcular precios!!!!!!
    }

    yield state.copyWith(
        km: state.km + kilometros,
        stoptimetoDisplay: '00:00:00',
        metaDistancia: pagoReal,
        pago: pagoReal,
        inicio: event.inicio);
  }

  double calculaPrecioFinal(double banderazo) {
    double miTotal = 0;
    for (var i = 0; i <= _puntosRuta.length - 1; i++) {
      miTotal += (_puntosRuta[i]["tarifa"] * _puntosRuta[i]["distancia"]);
    }
    miTotal = miTotal + banderazo;
    print("calculo mi totalote ======= $miTotal");
    return miTotal;
  }
}
