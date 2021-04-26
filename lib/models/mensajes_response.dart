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
    this.ok,
    this.mensajes,
  });

  bool ok;
  List<Mensaje> mensajes;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
      };
}

class Mensaje {
  Mensaje({
    this.idMensaje,
    this.titulo,
    this.mensaje,
    this.tipo,
    this.name,
    this.idStatus,
    this.estatus,
  });

  int idMensaje;
  String titulo;
  String mensaje;
  String tipo;
  String name;
  int idStatus;
  String estatus;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        idMensaje: json["id_mensaje"],
        titulo: json["titulo"],
        mensaje: json["mensaje"],
        tipo: json["tipo"],
        name: json["name"],
        idStatus: json["id_status"],
        estatus: json["Estatus"],
      );

  Map<String, dynamic> toJson() => {
        "id_mensaje": idMensaje,
        "titulo": titulo,
        "mensaje": mensaje,
        "tipo": tipo,
        "name": name,
        "id_status": idStatus,
        "Estatus": estatus,
      };
}
