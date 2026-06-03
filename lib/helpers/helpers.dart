import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor, LatLng;
import 'package:mapa_app/custom_markers.dart/custom_markers.dart';

part 'navegar_fadein.dart';
part 'calculando_alerta.dart';
part 'custom_image_markers.dart';
part 'widgets_to_marker.dart';
part 'confirmacion.dart';
part 'cotizando_helper.dart';
part 'modo_landscape.dart';
List<LatLng> decodePolyline(String encoded, {int precision = 6}) {
    final coordinates = <LatLng>[];
    final factor = precision == 0 ? 1.0 : precision == 5 ? 1e5 : 1e6;
    var index = 0;
    var latitude = 0;
    var longitude = 0;

    while (index < encoded.length) {
        var shift = 0;
        var result = 0;
        int byte;

        do {
            byte = encoded.codeUnitAt(index++) - 63;
            result |= (byte & 0x1f) << shift;
            shift += 5;
        } while (byte >= 0x20 && index < encoded.length + 1);

        final latitudeDelta = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
        latitude += latitudeDelta;

        shift = 0;
        result = 0;

        do {
            byte = encoded.codeUnitAt(index++) - 63;
            result |= (byte & 0x1f) << shift;
            shift += 5;
        } while (byte >= 0x20 && index < encoded.length + 1);

        final longitudeDelta = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
        longitude += longitudeDelta;

        coordinates.add(LatLng(latitude / factor, longitude / factor));
    }

    return coordinates;
}
