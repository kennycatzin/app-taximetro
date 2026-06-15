import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/helpers/debouncer.dart';
import 'package:mapa_app/models/reverse_query_response.dart';
import 'package:mapa_app/models/search_response.dart';
import 'package:mapa_app/models/traffic_response.dart';

class TrafficService {
  static const int _maxCacheEntries = 25;

  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  final Map<String, DrivingResponse> _routesCache = <String, DrivingResponse>{};
  final Map<String, Future<DrivingResponse>> _pendingRoutes =
      <String, Future<DrivingResponse>>{};
  final Map<String, SearchResponse> _searchCache = <String, SearchResponse>{};
  final Map<String, Future<SearchResponse>> _pendingSearches =
      <String, Future<SearchResponse>>{};
  final Map<String, ReverseQueryResponse> _reverseCache =
      <String, ReverseQueryResponse>{};
  final Map<String, Future<ReverseQueryResponse>> _pendingReverseQueries =
      <String, Future<ReverseQueryResponse>>{};
  String? _lastSuggestionKey;

  final StreamController<SearchResponse> _sugerenciasStreamController =
      new StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugerenciasStream =>
      this._sugerenciasStreamController.stream;

  final baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final apiKey =
      'pk.eyJ1Ijoia2VubnktMjUwNiIsImEiOiJjazl1YXU5c3cwY2pwM3JvMG5jOWszNW9yIn0.A4R59LR8q8KLdXmDmb-C_g';

  Future<DrivingResponse> getCoordsInicioYFin(
      LatLng inicio, LatLng destino) async {
    final cacheKey = _buildRouteKey(inicio, destino);
    final cachedRoute = _routesCache[cacheKey];
    if (cachedRoute != null) {
      return cachedRoute;
    }

    final pendingRoute = _pendingRoutes[cacheKey];
    if (pendingRoute != null) {
      return pendingRoute;
    }

    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this.baseUrlDir}/mapbox/driving/$coordString';
    final request = this._dio.get(url, queryParameters: {
      'alternatives': 'false',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this.apiKey,
      'language': 'es'
    }).then((resp) {
      final data = DrivingResponse.fromJson(resp.data);
      _rememberValue(_routesCache, cacheKey, data);
      return data;
    }).whenComplete(() => _pendingRoutes.remove(cacheKey));

    _pendingRoutes[cacheKey] = request;
    return request;
  }

  Future<SearchResponse> getResultadorPorQuery(
      String busqueda, LatLng proximidad) async {
    final normalizedQuery = busqueda.trim();
    if (normalizedQuery.isEmpty) {
      return const SearchResponse();
    }

    final cacheKey = _buildSearchKey(normalizedQuery, proximidad);
    final cachedSearch = _searchCache[cacheKey];
    if (cachedSearch != null) {
      return cachedSearch;
    }

    final pendingSearch = _pendingSearches[cacheKey];
    if (pendingSearch != null) {
      return pendingSearch;
    }

    final url =
        '${this.baseUrlGeo}/mapbox.places/${Uri.encodeComponent(normalizedQuery)}.json';
    final request =
        _fetchSearchResult(url, normalizedQuery, proximidad, cacheKey);

    _pendingSearches[cacheKey] = request;
    return request;
  }

  Future<SearchResponse> _fetchSearchResult(String url, String normalizedQuery,
      LatLng proximidad, String cacheKey) async {
    try {
      final resp = await this._dio.get(url, queryParameters: {
        'access_token': this.apiKey,
        'autocomplete': 'true',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });
      final searchResponse = searchResponseFromJson(resp.data);
      _rememberValue(_searchCache, cacheKey, searchResponse);
      return searchResponse;
    } catch (e) {
      return const SearchResponse();
    } finally {
      _pendingSearches.remove(cacheKey);
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    final normalizedQuery = busqueda.trim();
    if (normalizedQuery.isEmpty) {
      _lastSuggestionKey = null;
      return;
    }

    final cacheKey = _buildSearchKey(normalizedQuery, proximidad);
    if (_lastSuggestionKey == cacheKey) {
      final cachedSearch = _searchCache[cacheKey];
      if (cachedSearch != null) {
        this._sugerenciasStreamController.add(cachedSearch);
      }
      return;
    }

    _lastSuggestionKey = cacheKey;
    debouncer.onValue = (_) async {
      final resultados =
          await this.getResultadorPorQuery(normalizedQuery, proximidad);
      if (_lastSuggestionKey == cacheKey) {
        this._sugerenciasStreamController.add(resultados);
      }
    };
    debouncer.value = normalizedQuery;
  }

  Future<ReverseQueryResponse> getCoordenadasInfo(LatLng destinoCoords) async {
    final cacheKey = _buildReverseKey(destinoCoords);
    final cachedReverse = _reverseCache[cacheKey];
    if (cachedReverse != null) {
      return cachedReverse;
    }

    final pendingReverse = _pendingReverseQueries[cacheKey];
    if (pendingReverse != null) {
      return pendingReverse;
    }

    final url =
        '${this.baseUrlGeo}/mapbox.places/${destinoCoords.longitude},${destinoCoords.latitude}.json';
    final request = this._dio.get(url, queryParameters: {
      'access_token': this.apiKey,
      'language': 'es'
    }).then((resp) {
      final data = reverseQueryResponseFromJson(resp.data);
      _rememberValue(_reverseCache, cacheKey, data);
      return data;
    }).whenComplete(() => _pendingReverseQueries.remove(cacheKey));

    _pendingReverseQueries[cacheKey] = request;
    return request;
  }

  String _buildRouteKey(LatLng inicio, LatLng destino) {
    return 'route:${_normalizeCoord(inicio.latitude)},${_normalizeCoord(inicio.longitude)}|${_normalizeCoord(destino.latitude)},${_normalizeCoord(destino.longitude)}';
  }

  String _buildSearchKey(String query, LatLng proximidad) {
    return 'search:${query.toLowerCase()}|${_normalizeCoord(proximidad.latitude)},${_normalizeCoord(proximidad.longitude)}';
  }

  String _buildReverseKey(LatLng destinoCoords) {
    return 'reverse:${_normalizeCoord(destinoCoords.latitude)},${_normalizeCoord(destinoCoords.longitude)}';
  }

  String _normalizeCoord(double value) {
    return value.toStringAsFixed(5);
  }

  void _rememberValue<T>(Map<String, T> cache, String key, T value) {
    if (cache.length >= _maxCacheEntries && !cache.containsKey(key)) {
      cache.remove(cache.keys.first);
    }
    cache[key] = value;
  }
}
