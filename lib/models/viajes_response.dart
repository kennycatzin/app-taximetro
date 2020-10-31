// To parse this JSON data, do
//
//     final viajesResponse = viajesResponseFromJson(jsonString);

import 'dart:convert';

ViajesResponse viajesResponseFromJson(String str) =>
    ViajesResponse.fromJson(json.decode(str));

String viajesResponseToJson(ViajesResponse data) => json.encode(data.toJson());

class ViajesResponse {
  ViajesResponse({
    this.data,
    this.total,
  });

  List<Datum> data;
  int total;

  factory ViajesResponse.fromJson(Map<String, dynamic> json) => ViajesResponse(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}

class Datum {
  Datum({
    this.idViaje,
    this.km,
    this.horaInicio,
    this.horaTermino,
    this.precio,
    this.idChofer,
    this.usuarioCreacion,
    this.usuarioModificacion,
    this.fechaCreacion,
    this.fechaModificacion,
    this.activo,
  });

  int idViaje;
  double km;
  String horaInicio;
  String horaTermino;
  int precio;
  int idChofer;
  int usuarioCreacion;
  int usuarioModificacion;
  DateTime fechaCreacion;
  DateTime fechaModificacion;
  int activo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idViaje: json["id_viaje"],
        km: json["km"],
        horaInicio: json["hora_inicio"],
        horaTermino: json["hora_termino"],
        precio: json["precio"],
        idChofer: json["id_chofer"],
        usuarioCreacion: json["usuario_creacion"],
        usuarioModificacion: json["usuario_modificacion"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        activo: json["activo"],
      );

  Map<String, dynamic> toJson() => {
        "id_viaje": idViaje,
        "km": km,
        "hora_inicio": horaInicio,
        "hora_termino": horaTermino,
        "precio": precio,
        "id_chofer": idChofer,
        "usuario_creacion": usuarioCreacion,
        "usuario_modificacion": usuarioModificacion,
        "fecha_creacion": fechaCreacion.toIso8601String(),
        "fecha_modificacion": fechaModificacion.toIso8601String(),
        "activo": activo,
      };
}