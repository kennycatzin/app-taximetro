import 'dart:convert';

SearchResponse searchResponseFromJson(dynamic data) {
  final jsonMap = data is String
      ? json.decode(data) as Map<String, dynamic>
      : Map<String, dynamic>.from(data as Map);
  return SearchResponse.fromJson(jsonMap);
}

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  const SearchResponse({
    this.type = '',
    this.query = const [],
    this.features = const [],
    this.attribution = '',
  });

  final String type;
  final List<String> query;
  final List<Feature> features;
  final String attribution;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        type: json['type'] as String? ?? '',
        query: (json['query'] as List<dynamic>? ?? const [])
            .map((item) => item.toString())
            .toList(),
        features: (json['features'] as List<dynamic>? ?? const [])
            .map((item) => Feature.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        attribution: json['attribution'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'query': query,
        'features': features.map((item) => item.toJson()).toList(),
        'attribution': attribution,
      };
}

class Feature {
  const Feature({
    this.textEs = '',
    this.placeNameEs = '',
    this.center = const [],
  });

  final String textEs;
  final String placeNameEs;
  final List<double> center;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        textEs: (json['text_es'] ?? json['text']) as String? ?? '',
        placeNameEs:
            (json['place_name_es'] ?? json['place_name']) as String? ?? '',
        center: (json['center'] as List<dynamic>? ?? const [])
            .map((item) => (item as num).toDouble())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'text_es': textEs,
        'place_name_es': placeNameEs,
        'center': center,
      };
}
