part of 'widgets.dart';

class BtnsHelpers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taximetroState = BlocProvider.of<TaximetroBloc>(context).state;
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (!state.seleccionManual && !taximetroState.startIsPressed) {
          return _BuildBtnsHelpers();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildBtnsHelpers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 300, left: 170),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BtnUbicacion(),
          ],
        ),
      ),
    );
  }
}

// BtnMiRuta(), BtnSeguirUbicacion()
