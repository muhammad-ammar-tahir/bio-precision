
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/scanner_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/gemini_service.dart';
import 'diagnosis_result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showImageSourceSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.selectImage,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            _SourceOption(
              icon: Icons.camera_alt,
              label: l10n.takePhoto,
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
            _SourceOption(
              icon: Icons.photo_library,
              label: l10n.chooseGallery,
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final scanner = context.read<ScannerProvider>();
    await scanner.pickImage(source);
  }

  Future<void> _analyze() async {
    final scanner = context.read<ScannerProvider>();
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    final success = await scanner.analyzeImage(isUrdu: isUrdu);
    if (success && mounted) {
      context.read<HistoryProvider>().loadHistory();
      // Fade transition to result screen
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              DiagnosisResultScreen(result: scanner.result!),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    }
  }

  Future<void> _retry() async {
    final scanner = context.read<ScannerProvider>();
    final isUrdu = context.read<LocaleProvider>().isUrdu;
    final success = await scanner.retry(isUrdu: isUrdu);
    if (success && mounted) {
      context.read<HistoryProvider>().loadHistory();
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              DiagnosisResultScreen(result: scanner.result!),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    }
  }

  /// Friendly error message + optional Retry button.
  Widget _buildErrorBanner(ScannerProvider scanner, AppLocalizations l10n) {
    final errorType = scanner.errorType;
    final message = scanner.error ?? l10n.errorAnalyzing;

    Color bgColor = AppTheme.errorContainer.withValues(alpha: 0.4);
    Color textColor = AppTheme.error;
    IconData icon = Icons.error_outline;
    bool showRetry = true;

    if (errorType == GeminiErrorType.noInternet) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFF92400E);
      icon = Icons.wifi_off_outlined;
    } else if (errorType == GeminiErrorType.quotaExceeded) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      icon = Icons.block_outlined;
      showRetry = false;
    } else if (errorType == GeminiErrorType.notAPlant) {
      bgColor = const Color(0xFFF0FDF4);
      textColor = const Color(0xFF065F46);
      icon = Icons.grass_outlined;
      showRetry = false;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                if (showRetry) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: scanner.isAnalyzing ? null : _retry,
                    child: Text(
                      'Tap to Retry →',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scanner = context.watch<ScannerProvider>();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Image preview area
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image or placeholder
                    if (scanner.selectedImage != null)
                      Image.file(scanner.selectedImage!, fit: BoxFit.cover)
                    else
                      Container(
                        color: AppTheme.surfaceContainer,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.document_scanner_outlined,
                              size: 80,
                              color: AppTheme.primary.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.scanNow,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: AppTheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),

                    // Scanning reticle overlay
                    if (scanner.selectedImage != null)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Opacity(
                              opacity: scanner.isAnalyzing
                                  ? _pulseAnimation.value
                                  : 0.4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _ReticleCorner(top: true, left: true),
                                      _ReticleCorner(top: true, left: false),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _ReticleCorner(top: false, left: true),
                                      _ReticleCorner(top: false, left: false),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Loading overlay
                    if (scanner.isAnalyzing)
                      Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: AppTheme.primaryFixed,
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.analyzing,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Error banner
            if (scanner.error != null)
              _buildErrorBanner(scanner, l10n),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed:
                          scanner.isAnalyzing ? null : _showImageSourceSheet,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(l10n.selectImage),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                if (scanner.selectedImage != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppTheme.leafGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed:
                              scanner.isAnalyzing ? null : _analyze,
                          icon: const Icon(Icons.search,
                              color: Colors.white),
                          label: Text(
                            l10n.analyzeLeaf,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppTheme.secondary),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right,
                  color: AppTheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReticleCorner extends StatelessWidget {
  final bool top;
  final bool left;

  const _ReticleCorner({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: AppTheme.primaryFixed, width: 4)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: AppTheme.primaryFixed, width: 4)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: AppTheme.primaryFixed, width: 4)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: AppTheme.primaryFixed, width: 4)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(8) : Radius.zero,
          topRight: top && !left ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(8) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(8) : Radius.zero,
        ),
      ),
    );
  }
}
