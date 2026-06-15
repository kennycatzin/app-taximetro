part of 'widgets.dart';

class TaxistaPerfil extends StatefulWidget {
  const TaxistaPerfil({Key? key, required this.isLandscape}) : super(key: key);

  final bool isLandscape;

  @override
  _TaxistaPerfilState createState() => _TaxistaPerfilState();
}

class _TaxistaPerfilState extends State<TaxistaPerfil> {
  bool miStatus = true;
  final viajeProvider = new ViajesService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioBloc = context.read<UsuarioBloc>();
    final usuario = usuarioBloc.state;
    final panelWidth = widget.isLandscape
        ? max(min(size.width * .36, 360.0), 300.0)
        : min(size.width - 32, 400.0);

    return BlocBuilder<TaximetroBloc, TaximetroState>(
      builder: (context, state) => SizedBox(
        width: panelWidth,
        child: Container(
          padding: EdgeInsets.all(widget.isLandscape ? 16 : 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: (usuario.centro_trabajo == "Mi taxi")
                  ? [
                      Colors.redAccent.withOpacity(0.94),
                      Color(0xFFD81B60).withOpacity(0.88),
                    ]
                  : [
                      Colors.blueGrey.shade900.withOpacity(0.95),
                      Colors.blueGrey.shade700.withOpacity(0.88),
                    ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isLandscape
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white60, width: 2.0),
                              ),
                              padding: EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(usuario.imagen),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usuario.nombre,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    usuario.numEconomico,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            _contenedorBlanco(usuario, context),
                          ],
                        ),
                        SizedBox(height: 10),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: _conectadoSocket(),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white60, width: 2.0),
                          ),
                          padding: EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(usuario.imagen),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usuario.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                usuario.numEconomico,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.0,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 10),
                              _conectadoSocket(),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        _contenedorBlanco(usuario, context),
                      ],
                    ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      icon: Icons.monetization_on,
                      label: 'Pago',
                      value: '\$${state.pago.toStringAsFixed(2)}',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _metricCard(
                      icon: Icons.local_taxi,
                      label: 'Kilómetros',
                      value: '${state.km.toStringAsFixed(3)} km',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: BtnMiViaje(isLandscape: widget.isLandscape),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenedorBlanco(usuarioState, BuildContext context) {
    return GestureDetector(
      onTap: () => guardarUbicacion(context),
      child: Container(
        width: widget.isLandscape ? 50 : 52,
        height: widget.isLandscape ? 50 : 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white24,
        ),
        padding: EdgeInsets.all(6.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(usuarioState.centro_imagen),
        ),
      ),
    );
  }

  Widget _conectadoSocket() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            miStatus ? Icons.online_prediction : Icons.offline_bolt,
            color: miStatus ? Colors.greenAccent : Colors.red[200],
            size: 18,
          ),
          SizedBox(width: 6),
          Text(
            miStatus ? 'Conectado' : 'Sin conexión',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void cambioStatus(status, UsuarioBloc usuarioBloc) {
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
        if (destino == null) {
          Navigator.of(context).pop();
          return;
        }
        Navigator.of(context).pop();
        mostrarLoading(context);
        await viajeProvider.guardarUbicacion(
            destino.latitude.toString(), destino.longitude.toString());
        if (!context.mounted) {
          return;
        }

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

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 22),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.isLandscape ? 18 : 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
