import 'dart:async';

import 'package:flutter/material.dart';

class CronometroPage extends StatefulWidget {
  @override
  _CronometroPageState createState() => _CronometroPageState();
}

class _CronometroPageState extends State<CronometroPage> {
  bool startIsPressed = true;
  int contador = 1;

  bool stopIsPressed = true;

  bool resetIsPressed = true;

  String stoptimetoDisplay = "00:00:00";

  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  void startTimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    if (swatch.isRunning) {
      startTimer();
    }
    setState(() {
      var sec = swatch.elapsed.inSeconds;
      var min = swatch.elapsed.inMinutes;
      var hora = swatch.elapsed.inHours;

      var total = (sec / 60) + min + (hora * 60);
      print("entro $sec $total");

      if ((sec / contador) == 30) {
        print("aqui consulta los precios ");
        contador++;
      }
      stoptimetoDisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  void startStopWatch() {
    setState(() {
      stopIsPressed = false;
      startIsPressed = false;
    });
    swatch.start();
    startTimer();
  }

  void stopstopwatch() {
    setState(() {
      stopIsPressed = true;
      resetIsPressed = false;
    });
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

  void resetstopwatch() {
    setState(() {
      startIsPressed = true;
      resetIsPressed = true;
    });
    swatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronómetro'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              stoptimetoDisplay,
              style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                  child: Container(
                    child: Text('Stop'),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 0.0,
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  onPressed: stopIsPressed ? null : stopstopwatch,
                ),
                SizedBox(
                  width: 150.0,
                ),
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                  child: Container(
                    child: Text('Reset'),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 0.0,
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  onPressed: resetIsPressed ? null : resetstopwatch,
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
              child: Container(
                child: Text('Start'),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.0,
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: startIsPressed ? startStopWatch : null,
            ),
          ],
        ),
      ),
    );
  }
}
