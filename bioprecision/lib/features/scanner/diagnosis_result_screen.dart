import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/translation_service.dart';
import '../../models/diagnosis_result.dart';
import '../../providers/locale_provider.dart';

class DiagnosisResultScreen extends StatelessWidget {
  final DiagnosisResult result;

  const DiagnosisResultScreen({super.key, required this.result});

  // ── Translation helpers ───────────────────────────────────────────────────
  String _displayDisease(BuildContext context) {
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    if (!isUrdu) return result.diseaseName;
    return TranslationService.translateDisease(result.diseaseName);
  }

  String _displayPlant(BuildContext context) {
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    if (!isUrdu) return result.plantName;
    return TranslationService.translateCrop(result.plantName);
  }

  Future<String> _displayOrganic(BuildContext context) async {
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    if (!isUrdu) return result.organicSolution;
    return TranslationService.translateTreatmentAsync(result.organicSolution);
  }

  Future<String> _displayChemical(BuildContext context) async {
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    if (!isUrdu) return result.chemicalSolution;
    return TranslationService.translateTreatmentAsync(result.chemicalSolution);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Watch locale so screen rebuilds when user switches language
    context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNav(context),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroImage(context),
                    const SizedBox(height: 24),
                    _buildDiagnosisHeader(context, l10n),
                    const SizedBox(height: 28),
                    _buildTreatmentPlan(context, l10n),
                    const SizedBox(height: 24),
                    _buildChemicalSolution(context, l10n),
                    const SizedBox(height: 32),
                    _buildPrimaryAction(context, l10n),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Nav ──────────────────────────────────────────────────────────────
  Widget _buildTopNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: Color(0xFF0F172A)),
            ),
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.biotech, color: AppTheme.primary),
              ),
              const SizedBox(width: 10),
              const Text(
                'BioPrecision',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.surfaceContainerHighest,
            child: ClipOval(
              child: Image.network(
                kProfileAvatarUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero Image ───────────────────────────────────────────────────────────
  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 1,
            child: result.imagePath.startsWith('http')
                ? Image.network(result.imagePath, fit: BoxFit.cover)
                : Image.file(File(result.imagePath), fit: BoxFit.cover),
          ),
        ),
        // Corner brackets
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bracket(top: true, left: true),
                    _bracket(top: true, left: false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bracket(top: false, left: true),
                    _bracket(top: false, left: false),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Confidence badge
        Positioned(
          top: 16,
          right: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      result.isHealthy
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                      color: result.isHealthy
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${result.confidence.round()}% Confidence',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xFF064E3B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Timestamp
        Positioned(
          bottom: 16,
          left: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  DateFormat('dd MMM yyyy • hh:mm a')
                      .format(result.timestamp),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bracket({required bool top, required bool left}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: Colors.white, width: 2.5)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: Colors.white, width: 2.5)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: Colors.white, width: 2.5)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: Colors.white, width: 2.5)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(12) : Radius.zero,
          topRight: top && !left ? const Radius.circular(12) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(12) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(12) : Radius.zero,
        ),
      ),
    );
  }

  // ── Diagnosis Header ─────────────────────────────────────────────────────
  Widget _buildDiagnosisHeader(BuildContext context, AppLocalizations l10n) {
    final isHealthy = result.isHealthy;
    final alertColor =
        isHealthy ? const Color(0xFF065F46) : const Color(0xFF991B1B);
    final alertBg =
        isHealthy ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
    final isUrdu = context.watch<LocaleProvider>().isUrdu;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: alertBg,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                isHealthy
                    ? (isUrdu ? '✅  صحت مند' : '✅  HEALTHY')
                    : (isUrdu ? '⚠️  بیماری پائی گئی' : '⚠️  DISEASE DETECTED'),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: alertColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Disease name — translated
        Text(
          _displayDisease(context),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Color(0xFF0F172A),
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        // Plant name — translated
        Row(
          children: [
            const Icon(Icons.eco, color: Color(0xFF10B981), size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _displayPlant(context),
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Confidence bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isUrdu ? 'AI اعتماد کی سطح' : 'AI Confidence Level',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${result.confidence.round()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _confidenceColor(result.confidence),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: result.confidence / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                    _confidenceColor(result.confidence)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _confidenceColor(double c) {
    if (c >= 85) return const Color(0xFF10B981);
    if (c >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  // ── Organic Treatment Plan ────────────────────────────────────────────────
  Widget _buildTreatmentPlan(BuildContext context, AppLocalizations l10n) {
    final isUrdu = context.watch<LocaleProvider>().isUrdu;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.spa, color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 8),
            Text(
              isUrdu ? 'نامیاتی علاج' : 'Organic Treatment',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF86EFAC), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.spa,
                    color: Color(0xFF10B981), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FutureBuilder<String>(
                  future: _displayOrganic(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF14532D),
                        height: 1.6,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Chemical Solution ─────────────────────────────────────────────────────
  Widget _buildChemicalSolution(BuildContext context, AppLocalizations l10n) {
    final isUrdu = context.watch<LocaleProvider>().isUrdu;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.science, color: Color(0xFF6366F1), size: 20),
            const SizedBox(width: 8),
            Text(
              isUrdu ? 'کیمیائی علاج' : 'Chemical Treatment',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFA5B4FC), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.science,
                    color: Color(0xFF6366F1), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FutureBuilder<String>(
                  future: _displayChemical(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3730A3),
                        height: 1.6,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Primary Action ────────────────────────────────────────────────────────
  Widget _buildPrimaryAction(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppTheme.leafGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.savedToHistory),
                backgroundColor: const Color(0xFF059669),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.library_add_check,
              size: 22, color: Colors.white),
          label: Text(
            l10n.savedToHistory,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
