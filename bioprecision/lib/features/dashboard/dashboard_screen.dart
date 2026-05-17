import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/weather_provider.dart';
import '../../providers/history_provider.dart';
import 'widgets/vitality_hero.dart';
import 'widgets/weather_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/recent_insights.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToHistory;

  const DashboardScreen({super.key, required this.onNavigateToHistory});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather();
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weatherProvider = context.watch<WeatherProvider>();
    final weather = weatherProvider.weatherData;
    
    // Simulate soil moisture based on fetched humidity (e.g., 60-80% of humidity, bounded)
    int soilMoisture = 42;
    if (weather != null && weather.humidity > 0) {
      soilMoisture = (weather.humidity * 0.7).round().clamp(10, 95);
    }

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          final weatherProvider = context.read<WeatherProvider>();
          final historyProvider = context.read<HistoryProvider>();
          await weatherProvider.fetchWeather();
          await historyProvider.loadHistory();
        },
        color: AppTheme.primary,
        child: CustomScrollView(
          slivers: [
            // ── Top App Bar ──
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: const Color(0xFFECFDF5).withValues(alpha: 0.7),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.transparent),
                ),
              ),
              title: Row(
                children: [
                  const Icon(Icons.eco, color: AppTheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: const Color(0xFF022C22),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.surfaceContainerHighest,
                    child: ClipOval(
                      child: Image.network(
                        kProfileAvatarUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Body ──
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Vitality Hero
                  const VitalityHero(),
                  const SizedBox(height: 32),

                  // Weather Card
                  const WeatherCard(),
                  const SizedBox(height: 16),

                  // Stat Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.water_drop_outlined,
                          title: l10n.soilMoisture,
                          value: '$soilMoisture%',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          icon: Icons.compost,
                          title: l10n.npkLevels,
                          value: l10n.optimal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Recent Insights
                  RecentInsights(onSeeHistory: widget.onNavigateToHistory),
                  const SizedBox(height: 100), // bottom padding for nav
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
