import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  String _cityName = '';

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get cityName => _cityName;

  Future<void> fetchWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      _cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );
      _weatherData = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Use placeholder data so UI is never empty
      _weatherData = WeatherData.placeholder();
      _cityName = 'Location unavailable';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
