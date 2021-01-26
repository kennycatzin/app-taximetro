import 'package:flutter/material.dart';

import 'package:mapa_app/bloc/login/login.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  //Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context, {bool listen}) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
