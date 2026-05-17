import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../../providers/weather_provider.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final weather = weatherProvider.weatherData;
    final isLoading = weatherProvider.isLoading;

    if (isLoading && weather == null) {
      return _buildShimmer();
    }

    return _buildCard(context, weatherProvider);
  }

  // ── Main Card ──────────────────────────────────────────────────────────────
  Widget _buildCard(BuildContext context, WeatherProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final weather = provider.weatherData;
    final cityName = provider.cityName.isNotEmpty
        ? provider.cityName
        : (weather?.cityName ?? 'Loading...');
    final hasError = provider.error != null && weather == null;

    final gradientColors = _gradientFor(weather?.iconCode ?? '01d');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: hasError
                ? _buildError(context, provider, l10n)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, cityName, provider, l10n),
                      const SizedBox(height: 20),
                      _buildTemperatureRow(context, weather, l10n),
                      const SizedBox(height: 24),
                      _buildDivider(),
                      const SizedBox(height: 20),
                      _buildMetricsRow(context, weather, l10n),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ── Header: location + refresh button ─────────────────────────────────────
  Widget _buildHeader(BuildContext context, String cityName,
      WeatherProvider provider, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.localClimate.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      cityName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Refresh button
        GestureDetector(
          onTap: () => provider.fetchWeather(),
          child: provider.isLoading
              ? const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(Icons.refresh,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // ── Temperature + condition ────────────────────────────────────────────────
  Widget _buildTemperatureRow(
      BuildContext context, dynamic weather, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Big temperature
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: weather != null
                          ? '${weather.temperature.round()}'
                          : '--',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: -2,
                      ),
                    ),
                    const TextSpan(
                      text: '°C',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              if (weather != null) ...[
                Text(
                  weather.descriptionCapitalized,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Feels like ${weather.feelsLike.round()}°C',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Weather icon
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _weatherIcon(weather?.iconCode ?? '01d'),
            size: 52,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ── Divider line ──────────────────────────────────────────────────────────
  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ── Metrics row: humidity | wind | UV ─────────────────────────────────────
  Widget _buildMetricsRow(
      BuildContext context, dynamic weather, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _metric(
          icon: Icons.water_drop_outlined,
          label: l10n.humidity,
          value: weather != null ? '${weather.humidity}%' : '--',
        ),
        _verticalDivider(),
        _metric(
          icon: Icons.air,
          label: 'Wind',
          value: weather != null ? weather.windSpeedLabel : '--',
        ),
        _verticalDivider(),
        _metric(
          icon: Icons.wb_sunny_outlined,
          label: l10n.uvIndex,
          value: weather != null ? weather.uvLabel : '--',
        ),
      ],
    );
  }

  Widget _metric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.65),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 48,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, WeatherProvider provider,
      AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.location_off, color: Colors.white70, size: 40),
        const SizedBox(height: 12),
        Text(
          l10n.errorLoadingWeather,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: provider.fetchWeather,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Shimmer loading ────────────────────────────────────────────────────────
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2D7A4F),
      highlightColor: const Color(0xFF3FA066),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFF2D7A4F),
        ),
      ),
    );
  }

  // ── Gradient per weather condition ─────────────────────────────────────────
  List<Color> _gradientFor(String code) {
    if (code.contains('01')) {
      // Clear sky — warm gold
      return [const Color(0xFFE67E22), const Color(0xFFF39C12)];
    }
    if (code.contains('02') || code.contains('03')) {
      // Few/scattered clouds — teal green
      return [const Color(0xFF1A6B4A), const Color(0xFF2E9E6E)];
    }
    if (code.contains('04')) {
      // Overcast — slate blue-grey
      return [const Color(0xFF4A5568), const Color(0xFF718096)];
    }
    if (code.contains('09') || code.contains('10')) {
      // Rain — deep blue
      return [const Color(0xFF2563EB), const Color(0xFF1D4ED8)];
    }
    if (code.contains('11')) {
      // Thunderstorm — dark purple
      return [const Color(0xFF4C1D95), const Color(0xFF6D28D9)];
    }
    if (code.contains('13')) {
      // Snow — icy blue
      return [const Color(0xFF60A5FA), const Color(0xFF93C5FD)];
    }
    if (code.contains('50')) {
      // Mist/fog — muted teal
      return [const Color(0xFF2C7873), const Color(0xFF52958B)];
    }
    // Default — app green
    return [const Color(0xFF166534), const Color(0xFF16A34A)];
  }

  // ── Icon per weather code ──────────────────────────────────────────────────
  // IconData _weatherIcon(String code) {
  //   if (code.contains('01')) return Icons.wb_sunny_rounded;
  //   if (code.contains('02')) return Icons.partly_cloudy_day_rounded;
  //   if (code.contains('03') || code.contains('04')) return Icons.cloud_rounded;
  //   if (code.contains('09')) return Icons.grain;
  //   if (code.contains('10')) return Icons.umbrella_rounded;
  //   if (code.contains('11')) return Icons.flash_on_rounded;
  //   if (code.contains('13')) return Icons.ac_unit_rounded;
  //   if (code.contains('50')) return Icons.blur_on_rounded;
  //   return Icons.wb_cloudy_rounded;
  // }

  IconData _weatherIcon(String code) {
  if (code.contains('01')) return Icons.wb_sunny_rounded;     // clear sky
  if (code.contains('02')) return Icons.wb_cloudy_rounded;    // few clouds (FIXED)
  if (code.contains('03') || code.contains('04')) return Icons.cloud_rounded; // clouds
  if (code.contains('09')) return Icons.grain;                // shower rain
  if (code.contains('10')) return Icons.umbrella_rounded;     // rain
  if (code.contains('11')) return Icons.flash_on_rounded;     // thunderstorm
  if (code.contains('13')) return Icons.ac_unit_rounded;      // snow
  if (code.contains('50')) return Icons.blur_on_rounded;      // mist
  return Icons.wb_cloudy_rounded;                             // default
}
}
