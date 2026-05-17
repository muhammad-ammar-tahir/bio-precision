import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/history_provider.dart';

class VitalityHero extends StatelessWidget {
  const VitalityHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyProvider = context.watch<HistoryProvider>();
    final percent = historyProvider.healthyPercent;
    final change = historyProvider.totalScans > 0 ? 4 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + headline + badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.currentVitality,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.healthyPercent(percent),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            if (change > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  l10n.upPercent(change),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Hero Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 192,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB9FLgL-gpkVef-P0sEqbprUglMHECDDwNiZ5yCs2348MnyP0Suhy8T5H76n4F0dZHkKvdHICqbl6RUKV8_BIKDWCfvho6blbDqr8GMSkkbZMih2xarVoFDTT89XZR0e6Wxz7M1JUHgwjOKfCV20Q03KqVYCHVZQzdR0mLY1BdZ40XrwL0qXBSXkP2NCutas2pZJQD_p7evqjh-py-ZoRD0ZDKtw_KPIyKO0ykW6_1wvwmH6gA4q4Onnv8BfJljcpbFuQCADBqwXF4',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.9),
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.surfaceContainerLow,
                    child: const Icon(Icons.eco, size: 64, color: AppTheme.primary),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Glass chip at bottom
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: AppTheme.glassDecoration(borderRadius: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.eco_outlined, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.optimalRange,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                letterSpacing: 1,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              l10n.stableClimate,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
