part of 'widgets.dart';

class BtnUbicacion extends StatelessWidget {
  bool boton = true;
  @override
  Widget build(BuildContext context) {
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
                  size: 10.0, color: Colors.transparent),
            )
          ]),
          onPressed: () => verificarMensajes(context),
        ),
      ),
    );
  }

//() => verificarMensajes(context),
  void verificarMensajes(BuildContext context) async {
    final mensajesService = new MensajesService();
    Map info = await mensajesService.listaNuevoMensaje();
    print(info);
    if (info["ok"] == false) {
      Navigator.pushNamed(context, 'mensajes');
    } else {
      print("entrando a revisar");
      if (info['mensaje']['tipo'] == "CC") {
        _alertaConfirmaViaje(context, info);
      } else {
        _alertaMensajeNuevo(context, info);
      }
    }
  }

  void _alertaConfirmaViaje(BuildContext context, Map data) {
    // set up the buttons
    Widget cancelButton = ElevatedButton.icon(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // color: Colors.redAccent,
        // textColor: Colors.white,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        label: Text('Rechazar'),
        icon: Icon(Icons.cancel),
        onPressed: () => (boton == true)
            ? rechazar(context, data['mensaje']['id_mensaje'],
                data['mensaje']['id_viaje'])
            : null);

    Widget continueButton = ElevatedButton.icon(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // color: Colors.green,
      // textColor: Colors.white,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      label: Text('Aceptar'),
      icon: Icon(Icons.check_circle),
      onPressed: () => (boton == true) ? aceptar(context, data) : null,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("¿Desea aceptar viaje?")),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['mensaje']['titulo'],
                  style: new TextStyle(fontSize: 20.0)),
              Text(
                data['mensaje']['mensaje'],
              ),
            ],
          ),
        ),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _alertaMensajeNuevo(BuildContext context, Map data) {
    // set up the buttons

    Widget continueButton = ElevatedButton.icon(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // color: Colors.redAccent,
        // textColor: Colors.white,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        label: Text('Cerrar'),
        icon: Icon(Icons.cancel),
        onPressed: () => mensajeVisto(context, data["mensaje"]["id_mensaje"]));
    // onPressed: () => (boton == true)
    //     ? mensajeVisto(context, data["mensaje"]["id_mensaje"])
    //     : null);

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text(data['mensaje']['titulo'])),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(data['mensaje']['name'],
                  style: new TextStyle(fontSize: 20.0)),
              Text(
                data['mensaje']['mensaje'],
              ),
            ],
          ),
        ),
      ),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void aceptar(BuildContext context, Map mensaje) async {
    mostrarLoading(context);
    boton = false;
    final viajeProvider = new MensajesService();
    await viajeProvider.aceptarViajeMensaje(mensaje["mensaje"]["id_viaje"]);
    final mensajeBloc = BlocProvider.of<MensajeBloc>(context);
    final tarifaBloc = BlocProvider.of<TarifaBloc>(context);
    final tarifaState = BlocProvider.of<TarifaBloc>(context).state;
    // TODO: Tomar el precio de la central
    tarifaBloc.add(OnSetCentralPrice(
        tarifaState.tarifaMinimaCentral, tarifaState.tarifaMinima));

    mensajeBloc.add(OnTapMensaje(
      mensaje["mensaje"]["id_mensaje"],
      mensaje["mensaje"]["titulo"],
      mensaje["mensaje"]["mensaje"],
      mensaje["mensaje"]["tipo"],
      mensaje["mensaje"]["name"],
      mensaje["mensaje"]["telefono"],
      mensaje["mensaje"]["correo"],
    ));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.pushNamed(context, 'detalle_mensaje');
  }

  void rechazar(BuildContext context, int id_mensaje, int id_viaje) async {
    mostrarLoading(context);

    boton = false;
    final viajeProvider = new MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    await viajeProvider.rechazarViajeMensaje(id_viaje);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void mensajeVisto(BuildContext context, int id_mensaje) async {
    mostrarLoading(context);
    boton = false;
    final viajeProvider = new MensajesService();
    await viajeProvider.mensajeVisto(id_mensaje);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
