part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
        builder: (context, state) => this._crearBoton(context, state));
  }

  Widget _crearBoton(BuildContext context, MapaState state) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: CircleBorder(),
      child: IconButton(
        tooltip: 'Salir',
        padding: EdgeInsets.all(14),
        icon: Icon(Icons.exit_to_app_outlined, color: Colors.black87),
        onPressed: () {
          _alertaConfirmacionInicio(context);
        },
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
