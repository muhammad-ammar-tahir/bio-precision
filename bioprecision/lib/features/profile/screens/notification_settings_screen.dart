import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/user_profile_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  void _showSnack(BuildContext context, String label, bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label ${enabled ? 'enabled' : 'disabled'}'),
        backgroundColor: enabled ? AppTheme.primary : AppTheme.onSurfaceVariant,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileProvider>();
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryFixedDim.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Notification preferences are saved locally and applied when the app is active.',
                    style: TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _NotifTile(
            icon: Icons.bug_report_outlined,
            iconColor: AppTheme.error,
            title: 'Disease Alerts',
            subtitle: 'Get notified when a disease scan is complete',
            value: profile.diseaseAlerts,
            onChanged: (v) {
              profile.setDiseaseAlerts(v);
              _showSnack(context, 'Disease Alerts', v);
            },
          ),
          const SizedBox(height: 12),
          _NotifTile(
            icon: Icons.cloud_outlined,
            iconColor: const Color(0xFF0EA5E9),
            title: 'Weather Alerts',
            subtitle: 'Get notified about adverse weather conditions',
            value: profile.weatherAlerts,
            onChanged: (v) {
              profile.setWeatherAlerts(v);
              _showSnack(context, 'Weather Alerts', v);
            },
          ),
          const SizedBox(height: 12),
          _NotifTile(
            icon: Icons.lightbulb_outlined,
            iconColor: const Color(0xFFF59E0B),
            title: 'Usage Tips',
            subtitle: 'Receive tips on how to get the most from BioPrecision',
            value: profile.usageTips,
            onChanged: (v) {
              profile.setUsageTips(v);
              _showSnack(context, 'Usage Tips', v);
            },
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12, color: AppTheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primary,
            activeTrackColor: AppTheme.primaryFixedDim,
          ),
        ],
      ),
    );
  }
}
