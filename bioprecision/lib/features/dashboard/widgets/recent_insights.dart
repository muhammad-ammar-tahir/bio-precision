import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/history_provider.dart';
import '../../../models/diagnosis_result.dart';

class RecentInsights extends StatelessWidget {
  final VoidCallback onSeeHistory;

  const RecentInsights({super.key, required this.onSeeHistory});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyProvider = context.watch<HistoryProvider>();
    final recentScans = historyProvider.scans.take(2).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentInsights,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: onSeeHistory,
              child: Text(
                l10n.seeHistory,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recentScans.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.document_scanner_outlined,
                    size: 48, color: AppTheme.outlineVariant),
                const SizedBox(height: 12),
                Text(
                  l10n.noHistoryYet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        else
          ...recentScans.map((scan) => _InsightCard(scan: scan)),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final DiagnosisResult scan;
  const _InsightCard({required this.scan});

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}M';
    if (diff.inHours < 24) return '${diff.inHours}H';
    return '${diff.inDays}D';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: scan.imagePath.startsWith('http')
                  ? Image.network(scan.imagePath, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder())
                  : Image.file(File(scan.imagePath), fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder()),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.diseaseName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.confidence}: ${scan.confidence.round()}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scan.isHealthy
                        ? AppTheme.primary.withValues(alpha: 0.1)
                        : AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    scan.isHealthy ? l10n.stable : l10n.actionRequired,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: scan.isHealthy
                          ? AppTheme.primary
                          : AppTheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Time ago badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: AppTheme.glassDecoration(borderRadius: 8),
            child: Text(
              '${_timeAgo(scan.timestamp)} AGO',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.surfaceContainerLow,
      child: const Icon(Icons.eco, color: AppTheme.primary),
    );
  }
}
