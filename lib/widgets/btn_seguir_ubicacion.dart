part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
        builder: (context, state) => this._crearBoton(context, state));
  }

  Widget _crearBoton(BuildContext context, MapaState state) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
              // state.seguirUbicacion
              //   ? Icons.directions_run
              //   : Icons.accessibility_new,
              Icons.exit_to_app_outlined,
              color: Colors.black87),
          onPressed: () {
            // mapaBloc.add(OnSeguirUbicacion());
            _alertaConfirmacionInicio(context);
          },
        ),
      ),
    );
  }

  void _alertaConfirmacionInicio(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton.icon(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      // color: Colors.red,
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
      label: Text('Si'),
      icon: Icon(Icons.check_circle),
      onPressed: () {
        final taxiBloc = BlocProvider.of<TaximetroBloc>(context);
        final mapaBloc = BlocProvider.of<MapaBloc>(context);
        final authService = new UsuarioProvider();
        authService.logout();

        taxiBloc.add(OnIniciarValores());
        mapaBloc.add(OnQuitarPoliline());
        mapaBloc.add(OnMapaCrea());

        Navigator.of(context).pop();
        Navigator.pushNamed(context, 'login');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("¿Desea salir de la aplicación?"),
      actions: [
        cancelButton,
        continueButton,
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
}
