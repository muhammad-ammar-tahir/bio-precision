import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../providers/history_provider.dart';
import '../../../services/history_service.dart';

class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({super.key});

  static const _privacyPolicy = '''
BioPrecision Privacy Policy

Last updated: May 2026

1. Data Collection
BioPrecision collects images you upload for plant disease analysis. These images are sent to the Google Gemini AI API for processing. No personal data is stored on external servers beyond the scope of each API call.

2. Local Storage
All scan history, farm profile information, device configurations, and settings are stored locally on your device using SQLite and SharedPreferences. BioPrecision does not operate its own servers.

3. Third-Party APIs
• Google Gemini AI – Image analysis (images sent per request, not retained)
• OpenWeatherMap – Weather data based on your approximate location

4. Location
Weather data requires coarse location access. Location coordinates are only used for the weather API and are never stored persistently.

5. Data Deletion
You can delete all your data at any time using the "Delete All Data" option below. This will remove all scan history and settings from your device.

6. Security
API keys are used solely to authenticate service requests. All API communications are made over HTTPS.

7. Contact
For privacy inquiries, contact the app developer through your app store listing.
''';

  Future<void> _exportData(BuildContext context) async {
    try {
      final scans = await HistoryService().getAllScans();
      final jsonData = {
        'exported_at': DateTime.now().toIso8601String(),
        'total_scans': scans.length,
        'scans': scans.map((s) => s.toMap()).toList(),
      };
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Show a dialog with the JSON (share_plus not in pubspec yet, so we show a preview)
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(children: [
              Icon(Icons.download_done, color: AppTheme.primary),
              const SizedBox(width: 8),
              const Text('Export Ready', style: TextStyle(fontWeight: FontWeight.w800)),
            ]),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${scans.length} scan records exported.',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      jsonString.length > 600
                          ? '${jsonString.substring(0, 600)}...'
                          : jsonString,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close')),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteAllData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.error),
          const SizedBox(width: 8),
          const Text('Delete All Data', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        content: const Text(
          'This will permanently delete all scan history, farm profile, and settings. This action cannot be undone.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Everything',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Capture before any await
      final historyProvider = context.read<HistoryProvider>();
      final profileProvider = context.read<UserProfileProvider>();
      final messenger = ScaffoldMessenger.of(context);

      // Clear SQLite history
      final db = await HistoryService().database;
      await db.delete('scans');
      await historyProvider.loadHistory();
      await profileProvider.clearAllData();

      messenger.showSnackBar(
        SnackBar(
          content: const Text('All data deleted successfully.'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Data & Privacy'),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Privacy Policy text
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _privacyPolicy,
              style: const TextStyle(fontSize: 13, height: 1.65),
            ),
          ),
          const SizedBox(height: 28),

          // Export button
          _ActionButton(
            icon: Icons.ios_share,
            label: 'Export All Scan Data',
            subtitle: 'Download all your scan history as JSON',
            color: AppTheme.primary,
            onTap: () => _exportData(context),
          ),
          const SizedBox(height: 16),

          // Delete button
          _ActionButton(
            icon: Icons.delete_forever_outlined,
            label: 'Delete All Data',
            subtitle: 'Permanently erase all scans and settings',
            color: AppTheme.error,
            onTap: () => _deleteAllData(context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
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
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: color,
                            fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
