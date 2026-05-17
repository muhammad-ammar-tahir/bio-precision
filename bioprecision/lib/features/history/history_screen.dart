import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/translation_service.dart';
import '../../providers/history_provider.dart';
import '../../providers/locale_provider.dart';
import '../../models/diagnosis_result.dart';
import '../scanner/diagnosis_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyProvider = context.watch<HistoryProvider>();
    context.watch<LocaleProvider>(); // rebuild when language changes
    final filteredScans = _searchQuery.isEmpty
        ? historyProvider.scans
        : historyProvider.search(_searchQuery);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFECFDF5).withValues(alpha: 0.7),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.eco, color: Color(0xFF14532D), size: 20),
                ),
                const SizedBox(width: 12),
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
                      width: 40, height: 40, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Body ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),

                // Editorial header
                Text(
                  l10n.repository.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.primary,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.diseaseHistory,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.diseaseHistorySubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),

                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: l10n.searchDiseases,
                          hintStyle: TextStyle(
                            color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          prefixIcon: const Icon(Icons.search, size: 20,
                              color: AppTheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list,
                            color: AppTheme.onSurfaceVariant),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),

          // ── Scan cards ──
          if (filteredScans.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: AppTheme.neumorphicCard(),
                  child: Column(
                    children: [
                      Icon(Icons.document_scanner_outlined,
                          size: 56, color: AppTheme.outlineVariant),
                      const SizedBox(height: 16),
                      Text(l10n.noHistoryYet,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _HistoryCard(
                        scan: filteredScans[index],
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => DiagnosisResultScreen(
                                result: filteredScans[index]),
                          ));
                        },
                      ),
                    );
                  },
                  childCount: filteredScans.length,
                ),
              ),
            ),

          // ── Monthly Analytics ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            sliver: SliverToBoxAdapter(
              child: _MonthlyAnalytics(
                totalScans: historyProvider.totalScans,
                atRisk: historyProvider.atRiskCount,
                healthPercent: historyProvider.healthyPercent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final DiagnosisResult scan;
  final VoidCallback onTap;

  const _HistoryCard({required this.scan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    final displayDisease = isUrdu
        ? TranslationService.translateDisease(scan.diseaseName)
        : scan.diseaseName;
    final displayPlant = isUrdu
        ? TranslationService.translateCrop(scan.plantName)
        : scan.plantName;

    Color statusBgColor;
    Color statusTextColor;
    String statusText;

    if (scan.isHealthy) {
      statusBgColor = const Color(0xFFD1FAE5);
      statusTextColor = const Color(0xFF065F46);
      statusText = l10n.resolved;
    } else if (scan.confidence >= 90) {
      statusBgColor = const Color(0xFFFEE2E2);
      statusTextColor = const Color(0xFF991B1B);
      statusText = l10n.actionRequired;
    } else {
      statusBgColor = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFF92400E);
      statusText = l10n.underTreatment;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.neumorphicCard(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with confidence badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32)),
                      child: SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: scan.imagePath.startsWith('http')
                            ? Image.network(scan.imagePath, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _imgPlaceholder())
                            : Image.file(File(scan.imagePath), fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _imgPlaceholder()),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: AppTheme.glassDecoration(borderRadius: 9999),
                        child: Text(
                          '${scan.confidence.round()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF022C22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayDisease,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                if (isUrdu)
                                  Text(
                                    displayPlant,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.primary,
                                        fontStyle: FontStyle.italic),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: statusTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: AppTheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(scan.timestamp),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (scan.isHealthy)
                            Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppTheme.primary, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.cropHealthy,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            )
                          else
                            const SizedBox(),
                          Row(
                            children: [
                              Text(
                                l10n.viewReport,
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward,
                                  color: AppTheme.primary, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Decorative blur
            Positioned(
              bottom: -24,
              right: -24,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
    color: AppTheme.surfaceContainerLow,
    child: const Center(child: Icon(Icons.eco, size: 40, color: AppTheme.primary)),
  );

  String _formatDate(DateTime dt) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • ${h == 0 ? 12 : h}:$min $ampm';
  }
}

class _MonthlyAnalytics extends StatelessWidget {
  final int totalScans;
  final int atRisk;
  final int healthPercent;

  const _MonthlyAnalytics({
    required this.totalScans,
    required this.atRisk,
    required this.healthPercent,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.monthlyAnalytics,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _AnalyticItem(
                        label: l10n.scans,
                        value: totalScans.toString().padLeft(2, '0'),
                        color: AppTheme.primary,
                      ),
                      _AnalyticItem(
                        label: l10n.atRisk,
                        value: atRisk.toString().padLeft(2, '0'),
                        color: AppTheme.error,
                      ),
                      _AnalyticItem(
                        label: l10n.health,
                        value: '$healthPercent%',
                        color: AppTheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AnalyticItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
