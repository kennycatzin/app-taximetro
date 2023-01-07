part of 'widgets.dart';

class TaxistaPerfil extends StatefulWidget {
  @override
  _TaxistaPerfilState createState() => _TaxistaPerfilState();
}

class _TaxistaPerfilState extends State<TaxistaPerfil> {
  bool miStatus = true;
  final viajeProvider = new ViajesService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioState = BlocProvider.of<UsuarioBloc>(context);
    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          width: size.width * .38,
          child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (usuarioState.state.centro_trabajo == "Mi taxi")
                            ? [Colors.redAccent, Colors.redAccent]
                            : [
                                Colors.blueGrey.shade900,
                                Colors.blueGrey.shade900
                              ],
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  _conectadoSocket(size, usuarioState),
                  _cabeceraTaximetro(usuarioState),
                  _contenedorBlanco(size, usuarioState, context),
                  _contenedorItems(size),
                  BlocBuilder<TaximetroBloc, TaximetroState>(
                    builder: (context, state) =>
                        _contTaximetro(state, size, usuarioState),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _contenedorBlanco(
      Size size, UsuarioBloc usuarioState, BuildContext context) {
    return GestureDetector(
      onTap: () => guardarUbicacion(context),
      child: Align(
          alignment: Alignment(1, -1.0),
          child: Container(
            width: 70.0,
            height: 70.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundImage:
                    NetworkImage(usuarioState.state.centro_imagen)),
          )),
    );
  }

  Widget _conectadoSocket(Size size, UsuarioBloc usuarioBloc) {
    return GestureDetector(
      onTap: () => print("holaaa"),
      child: Container(
        margin: EdgeInsets.only(right: 198),
        child: Align(
            alignment: Alignment(1, -1.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
              padding: EdgeInsets.all(6.0),
              child: (miStatus)
                  ? Icon(Icons.online_prediction, color: Colors.greenAccent)
                  : Icon(Icons.offline_bolt, color: Colors.red[800]),
            )),
      ),
    );
  }

  void cambioStatus(status, UsuarioBloc usuarioBloc) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final ubicacionBloc = BlocProvider.of<MiUbicacionBloc>(context).state;
    print("hola beb");
  }

  void guardarUbicacion(BuildContext context) {
    // set up the buttons
    final destino = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    Widget cancelButton = ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.redAccent),
      ),

      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // color: Colors.redAccent,
      // textColor: Colors.white,
      label: Text('No'),
      icon: Icon(Icons.cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton.icon(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // color: Colors.green,
      // textColor: Colors.white,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),

      label: Text('Si'),
      icon: Icon(Icons.check_circle),
      onPressed: () async {
        Navigator.of(context).pop();
        mostrarLoading(context);
        Map info = await viajeProvider.guardarUbicacion(
            destino.latitude.toString(), destino.longitude.toString());
        print("guardando ubiaccion");
        print(destino.latitude);
        print(destino.longitude);

        Navigator.of(context).pop();
        const snackBar = SnackBar(
          content: Text('Se guardó la información'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("¿Desea guardar ubicación?")),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _contenedorItems(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * .440),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  Widget _cabeceraTaximetro(UsuarioBloc usuarioState) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white60, width: 2.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(usuarioState.state.imagen))),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(usuarioState.state.nombre,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: Colors.white)),
          Text(usuarioState.state.numEconomico,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _contTaximetro(
      TaximetroState state, Size size, UsuarioBloc usuarioState) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: size.height * .40),
          height: size.height * .37,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: Colors.black87,
                  ),
                  title: Text(
                    '${state.pago.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => {}),
              SizedBox(height: 10.0),
              ListTile(
                leading: Icon(
                  Icons.local_taxi,
                  color: Colors.black87,
                ),
                title: Text('${state.km.toStringAsFixed(3)}',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                onTap: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: 1.0),
        _tituloSindical(usuarioState)
      ],
    );
  }

  Widget _tituloSindical(UsuarioBloc usuarioState) {
    return Container(
      //margin: EdgeInsets.only(top: 330, left: 85),
      child: Text(
        usuarioState.state.tituloSindical,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
    );
  }
}
