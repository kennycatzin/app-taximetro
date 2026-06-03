// To parse this JSON data, do
//
//     final viajesResponse = viajesResponseFromJson(jsonString);

import 'dart:convert';

ViajesResponse viajesResponseFromJson(String str) =>
    ViajesResponse.fromJson(json.decode(str));

String viajesResponseToJson(ViajesResponse data) => json.encode(data.toJson());

class ViajesResponse {
  ViajesResponse({
    this.data = const [],
  });

  final List<Datum> data;

  factory ViajesResponse.fromJson(Map<String, dynamic> json) => ViajesResponse(
      data: List<Datum>.from(
          (json["data"] ?? []).map((x) => Datum.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.idViaje = 0,
    this.km = 0,
    this.horaInicio = '',
    this.horaTermino = '',
    this.precio = 0,
    this.idChofer = 0,
    this.tipo_viaje = 0,
    this.usuarioCreacion = 0,
    this.usuarioModificacion = 0,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  })  : fechaCreacion = fechaCreacion ?? DateTime.fromMillisecondsSinceEpoch(0),
        fechaModificacion =
            fechaModificacion ?? DateTime.fromMillisecondsSinceEpoch(0);

  final int idViaje;
  final double km;
  final String horaInicio;
  final String horaTermino;
  final double precio;
  final int idChofer;
  final int tipo_viaje;
  final int usuarioCreacion;
  final int usuarioModificacion;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idViaje: json["id_viaje"] ?? 0,
        km: (json["km"] as num?)?.toDouble() ?? 0,
        horaInicio: json["hora_inicio"] ?? '',
        horaTermino: json["hora_termino"] ?? '',
        precio: (json["precio"] as num?)?.toDouble() ?? 0,
        idChofer: json["id_chofer"] ?? 0,
        tipo_viaje: json["tipo_viaje"] ?? 0,
        usuarioCreacion: json["usuario_creacion"] ?? 0,
        usuarioModificacion: json["usuario_modificacion"] ?? 0,
        fechaCreacion: DateTime.tryParse(json["fecha_creacion"] ?? ''),
        fechaModificacion: DateTime.tryParse(json["fecha_modificacion"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id_viaje": idViaje,
        "km": km,
        "hora_inicio": horaInicio,
        "hora_termino": horaTermino,
        "precio": precio,
        "id_chofer": idChofer,
        "tipo_viaje": tipo_viaje,
        "usuario_creacion": usuarioCreacion,
        "usuario_modificacion": usuarioModificacion,
        "fecha_creacion": fechaCreacion.toIso8601String(),
        "fecha_modificacion": fechaModificacion.toIso8601String(),
      };
}
