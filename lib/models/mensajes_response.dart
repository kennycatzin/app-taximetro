// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    this.ok = false,
    this.mensajes = const [],
  });

  final bool ok;
  final List<Mensaje> mensajes;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        ok: json["ok"] ?? false,
        mensajes: List<Mensaje>.from(
            (json["mensajes"] ?? []).map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
      };
}

class Mensaje {
  Mensaje(
    {this.idMensaje = 0,
    this.titulo = '',
    this.mensaje = '',
    this.tipo = '',
    this.name = '',
    this.idStatus = 0,
    this.estatus = '',
    this.telefono = '',
    this.correo = ''});

  final int idMensaje;
  final String titulo;
  final String mensaje;
  final String tipo;
  final String name;
  final int idStatus;
  final String estatus;
  final String telefono;
  final String correo;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
    idMensaje: json["id_mensaje"] ?? 0,
    titulo: json["titulo"] ?? '',
    mensaje: json["mensaje"] ?? '',
    tipo: json["tipo"] ?? '',
    name: json["name"] ?? '',
    idStatus: json["id_status"] ?? 0,
    estatus: json["Estatus"] ?? '',
    telefono: json["telefono"] ?? '',
    correo: json["correo"] ?? '');

  Map<String, dynamic> toJson() => {
        "id_mensaje": idMensaje,
        "titulo": titulo,
        "mensaje": mensaje,
        "tipo": tipo,
        "name": name,
        "id_status": idStatus,
        "Estatus": estatus,
        "telefono": telefono,
        "correo": correo
      };
}
