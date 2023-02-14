import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/helpers/utils.dart';
import 'package:mapa_app/pages/loading_page.dart';
import 'package:mapa_app/pages/login_page.dart';
import 'package:mapa_app/services/socket_service.dart';
// import 'package:mapa_app/services/socket_service.dart';
import 'package:mapa_app/services/user_service.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class CargaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) {
            return Center(child: Text('Espere...'));
          }),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = new UsuarioProvider();
    final info = await authService.isLoggedIn();

    if (info["ok"] != "invalido") {
      // Navigator.pushReplacementNamed(context, 'usuarios');
      if (info['ok'] == 'true') {
        print(info['data']['operador']["imagen"]);
        final mapaBloc = BlocProvider.of<UsuarioBloc>(context);
        final tarifaBloc = BlocProvider.of<TarifaBloc>(context);
        final socketService =
            Provider.of<SocketService>(context, listen: false);
        final miMapa = BlocProvider.of<MapaBloc>(context);
        // socketService.connect();
        context
            .read<MapaBloc>()
            .add(OnTipoMapa(info['data']['operador']["id_centro_trabajo"]));
        //miMapa.add(OnTipoMapa(info['data']['operador']["id_centro_trabajo"]));
        mapaBloc.add(OnLogin(
            true,
            info['data']['operador']["id"],
            true,
            info['data']['operador']["imagen"],
            info['data']['operador']["centro_imagen"],
            info['data']['operador']["NumEconomico"],
            info['data']['operador']["TituloSindical"],
            info['data']['operador']["nombre"],
            info['data']['operador']["id_status"],
            info['data']['operador']["centro_trabajo"],
            info['data']['operador']["id_centro_trabajo"],
            info['data']['operador']["tipo_usuario"]));

        tarifaBloc.add(OnAsignarPrecios(
            info['data']['tarifas']["tarifa_minima"].toDouble(),
            info['data']['tarifas']["tarifa_minima_central"].toDouble(),
            info['data']['tarifas']["banderazo"].toDouble(),
            info['data']['tarifas']["intervalo_tiempo"],
            info['data']['tarifas']["intervalo_distancia"],
            info['data']['tarifas']["tarifa_tiempo"].toDouble(),
            info['data']['tarifas']["horarios"].toList()));

        if (info['data']['operador']["tipo_usuario"] == "SUPERVISOR") {
          Navigator.pushReplacementNamed(context, 'captura_supervisor');
        } else {
          Navigator.pushReplacementNamed(context, 'loading');
        }
      } else if (info['ok'] == 'false') {
        mostrarAlerta(context, info['mensaje']);
      } else if (info['ok'] == "pago") {
        mostrarAlerta(
            context, 'Falta de pago, favor de pasar a la secretaria.');
      }
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>
                  LoadingPage(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (
                _,
                __,
                ___,
              ) =>
                  LoginPage(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
