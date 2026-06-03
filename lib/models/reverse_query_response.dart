import 'dart:convert';

ReverseQueryResponse reverseQueryResponseFromJson(dynamic data) {
  final jsonMap = data is String
      ? json.decode(data) as Map<String, dynamic>
      : Map<String, dynamic>.from(data as Map);
  return ReverseQueryResponse.fromJson(jsonMap);
}

String reverseQueryResponseToJson(ReverseQueryResponse data) =>
    json.encode(data.toJson());

class ReverseQueryResponse {
  const ReverseQueryResponse({
    this.type = '',
    this.features = const [],
    this.attribution = '',
  });

  final String type;
  final List<Feature> features;
  final String attribution;

  factory ReverseQueryResponse.fromJson(Map<String, dynamic> json) =>
      ReverseQueryResponse(
        type: json['type'] as String? ?? '',
        features: (json['features'] as List<dynamic>? ?? const [])
            .map((item) => Feature.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        attribution: json['attribution'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'features': features.map((item) => item.toJson()).toList(),
        'attribution': attribution,
      };
}

class Feature {
  const Feature({
    this.placeNameEs = '',
  });

  final String placeNameEs;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        placeNameEs:
            (json['place_name_es'] ?? json['place_name']) as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'place_name_es': placeNameEs,
      };
}
