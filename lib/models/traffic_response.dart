import 'dart:convert';

DrivingResponse drivingResponseFromJson(dynamic data) {
  final jsonMap = data is String
      ? json.decode(data) as Map<String, dynamic>
      : Map<String, dynamic>.from(data as Map);
  return DrivingResponse.fromJson(jsonMap);
}

String drivingResponseToJson(DrivingResponse data) =>
    json.encode(data.toJson());

class DrivingResponse {
  const DrivingResponse({
    this.routes = const [],
    this.code = '',
    this.uuid = '',
  });

  final List<Route> routes;
  final String code;
  final String uuid;

  factory DrivingResponse.fromJson(Map<String, dynamic> json) => DrivingResponse(
        routes: (json['routes'] as List<dynamic>? ?? const [])
            .map((item) => Route.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        code: json['code'] as String? ?? '',
        uuid: json['uuid'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'routes': routes.map((item) => item.toJson()).toList(),
        'code': code,
        'uuid': uuid,
      };
}

class Route {
  const Route({
    this.duration = 0,
    this.distance = 0,
    this.geometry = '',
  });

  final double duration;
  final double distance;
  final String geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        duration: (json['duration'] as num?)?.toDouble() ?? 0,
        distance: (json['distance'] as num?)?.toDouble() ?? 0,
        geometry: json['geometry'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'distance': distance,
        'geometry': geometry,
      };
}
