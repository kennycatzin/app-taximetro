part of 'widgets.dart';

class TaxistaPerfil extends StatefulWidget {
  @override
  _TaxistaPerfilState createState() => _TaxistaPerfilState();
}

class _TaxistaPerfilState extends State<TaxistaPerfil> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioState = BlocProvider.of<UsuarioBloc>(context).state;
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
                        colors: [Colors.red, Colors.redAccent],
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  _cabeceraTaximetro(usuarioState),
                  _contenedorBlanco(size),
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

  Widget _contenedorBlanco(Size size) {
    return Align(
      alignment: Alignment(1, -1.0),
      child: Container(
          width: 70.0,
          height: 70.0,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.local_taxi,
            color: Colors.white,
          )),
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

  Widget _cabeceraTaximetro(UsuarioState usuarioState) {
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
                      backgroundImage: NetworkImage(usuarioState.imagen))),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(usuarioState.nombre,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: Colors.white)),
          Text(usuarioState.numEconomico,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _contTaximetro(
      TaximetroState state, Size size, UsuarioState usuarioState) {
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

  Widget _tituloSindical(UsuarioState usuarioState) {
    return Container(
      //margin: EdgeInsets.only(top: 330, left: 85),
      child: Text(
        usuarioState.tituloSindical,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
    );
  }
}
