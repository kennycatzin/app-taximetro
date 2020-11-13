import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mapa_app/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';

import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/tarifa/tarifa_bloc.dart';
import 'package:mapa_app/bloc/taximetro/taximetro_bloc.dart';
import 'package:mapa_app/bloc/usuario/usuario_bloc.dart';
import 'package:mapa_app/helpers/helpers.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:mapa_app/search/search_destination.dart';
import 'package:mapa_app/services/traffic_service.dart';
import 'package:polyline/polyline.dart' as Poly;
import 'dart:async';

part 'btn_ubicacion.dart';
part 'btn_mi_ruta.dart';
part 'btn_seguir_ubicacion.dart';
part 'searchbar.dart';
part 'marcador_manual.dart';
part 'taxista_perfil.dart';
part 'btn_mi_viaje.dart';
part 'btns_helpers.dart';
