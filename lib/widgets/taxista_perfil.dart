part of 'widgets.dart';

class TaxistaPerfil extends StatefulWidget {
  @override
  _TaxistaPerfilState createState() => _TaxistaPerfilState();
}

class _TaxistaPerfilState extends State<TaxistaPerfil> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  _cabeceraTaximetro(),
                  _contenedorBlanco(size),
                  _contenedorItems(size),
                  BlocBuilder<TaximetroBloc, TaximetroState>(
                    builder: (context, state) => _contTaximetro(state, size),
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
      margin: EdgeInsets.only(top: size.height * .398),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  Widget _cabeceraTaximetro() {
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
                      backgroundImage: AssetImage('assets/avatar.jpg'))),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text("Jonathan Hernández",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,
                  color: Colors.white)),
          Text("Unidad X-0000",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _contTaximetro(TaximetroState state, Size size) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: size.height * .34),
          height: size.height * .42,
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
                  title: Text(state.pago.toString()),
                  onTap: () => {}),
              ListTile(
                leading: Icon(
                  Icons.local_taxi,
                  color: Colors.black87,
                ),
                title: Text(state.km.toString()),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.timer,
                  color: Colors.black87,
                ),
                title: Text(state.stoptimetoDisplay),
                onTap: () {},
              )
            ],
          ),
        ),
        SizedBox(height: 25.0),
        _tituloSindical()
      ],
    );
  }

  Widget _tituloSindical() {
    return Container(
      //margin: EdgeInsets.only(top: 330, left: 85),
      child: Text(
        'X-0000',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      ),
    );
  }
}
