class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double uvIndex;
  final double windSpeed;
  final String description;
  final String iconCode;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.uvIndex,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
  });

  /// "partly cloudy" → "Partly Cloudy"
  String get descriptionCapitalized {
    if (description.isEmpty) return '';
    return description[0].toUpperCase() + description.substring(1);
  }

  String get uvLabel {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  String get windSpeedLabel => '${windSpeed.round()} m/s';

  factory WeatherData.fromJson(
    Map<String, dynamic> weatherJson, {
    double uvValue = 0,
  }) {
    final main = weatherJson['main'] as Map<String, dynamic>;
    final weather =
        (weatherJson['weather'] as List).first as Map<String, dynamic>;
    final wind = weatherJson['wind'] as Map<String, dynamic>? ?? {};

    return WeatherData(
      cityName: weatherJson['name'] as String? ?? 'Unknown',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num?)?.toDouble() ??
          (main['temp'] as num).toDouble(),
      humidity: main['humidity'] as int,
      uvIndex: uvValue,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
      description: weather['description'] as String? ?? '',
      iconCode: weather['icon'] as String? ?? '01d',
    );
  }

  factory WeatherData.placeholder() {
    return WeatherData(
      cityName: 'Location unavailable',
      temperature: 0,
      feelsLike: 0,
      humidity: 55,
      uvIndex: 6,
      windSpeed: 3.5,
      description: 'partly cloudy',
      iconCode: '02d',
    );
  }
}
