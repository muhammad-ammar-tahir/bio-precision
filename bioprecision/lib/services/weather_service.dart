import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/weather_data.dart';

class WeatherService {
  WeatherData? _cached;
  DateTime? _lastFetch;
  static const _cacheDuration = Duration(minutes: 15);

  Future<WeatherData> getWeather(double lat, double lon) async {
    // Return cached if fresh
    if (_cached != null &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < _cacheDuration) {
      return _cached!;
    }

    try {
      // Fetch current weather
      final weatherUri = Uri.parse(
        '$WEATHER_BASE_URL?lat=$lat&lon=$lon&appid=$API_KEY_WEATHER&units=metric',
      );
      final weatherRes = await http.get(weatherUri);

      if (weatherRes.statusCode != 200) {
        throw Exception('Weather API error: ${weatherRes.statusCode}');
      }

      final weatherJson = jsonDecode(weatherRes.body) as Map<String, dynamic>;

      // Try to fetch UV Index (may fail on free tier)
      double uvValue = 0;
      try {
        final uvUri = Uri.parse(
          '$UV_BASE_URL?lat=$lat&lon=$lon&appid=$API_KEY_WEATHER',
        );
        final uvRes = await http.get(uvUri);
        if (uvRes.statusCode == 200) {
          final uvJson = jsonDecode(uvRes.body);
          uvValue = (uvJson['value'] as num?)?.toDouble() ?? 0;
        }
      } catch (_) {
        // UV endpoint may not be available on free tier — fallback to 0
      }

      _cached = WeatherData.fromJson(weatherJson, uvValue: uvValue);
      _lastFetch = DateTime.now();
      return _cached!;
    } catch (e) {
      // If we have cached data, return it even if stale
      if (_cached != null) return _cached!;
      rethrow;
    }
  }

  void clearCache() {
    _cached = null;
    _lastFetch = null;
  }
}
