part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
        builder: (context, state) => this._crearBoton(context, state));
  }

  Widget _crearBoton(BuildContext context, MapaState state) {
    final mapaBloc = context.bloc<MapaBloc>();

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
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar"),
      onPressed: () {
        final taxiBloc = context.bloc<TaximetroBloc>();
        final mapaBloc = context.bloc<MapaBloc>();
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
      title: Text("Alerta de confirmación"),
      content: Text("¿Desea salir de la aplicación?"),
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
