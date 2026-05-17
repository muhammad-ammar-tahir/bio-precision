import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bioprecision/core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/history_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/user_profile_provider.dart';
import 'screens/farm_profile_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/device_management_screen.dart';
import 'screens/data_privacy_screen.dart';
import 'screens/subscription_plan_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  void _navigate(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyProvider = context.watch<HistoryProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final weatherProvider = context.watch<WeatherProvider>();
    final profileProvider = context.watch<UserProfileProvider>();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.surface.withValues(alpha: 0.7),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF14532D)),
              onPressed: () {},
            ),
            centerTitle: true,
            title: Text(
              l10n.profile,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF14532D),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF14532D)),
                onPressed: () {},
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),

                // ── Profile Header ──
                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.leafGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.surfaceContainerLow,
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCYoNHJn5AkP2KchdtoMXFmt-WScZf5vy_mmz8qVkCU8tV_vtCOv3T5m3JSbHlh5Y6q1sznyMMawK5WYD5jQTo0nujaBHNoBP0Xif9MiYoNlAFEqagmvXRGCe5AOuPnqloeCaP9_n--cqzyWzSEpwF-mh160hXsHHPPkz0Wyh5T3xjYSg1zJaaRjgaydMKObwyfTmFrumxkc9ItWe5yVQ5zpT3LPpHDq5PqjxA_hMxFgEBwGgghb4puguN9sdbkqz1WZH598XSmLvs',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppTheme.surfaceContainerLow,
                                    child: const Icon(Icons.person,
                                        size: 48, color: AppTheme.primary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Premium badge
                          Positioned(
                            bottom: -8,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                    color: AppTheme.surface, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.workspace_premium,
                                      color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    profileProvider.plan.contains('Pro')
                                        ? l10n.premium
                                        : 'FREE',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        profileProvider.farmName,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: AppTheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            weatherProvider.cityName.isNotEmpty
                                ? weatherProvider.cityName
                                : 'Sacramento Valley, CA',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (profileProvider.cropTypes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          profileProvider.cropTypes.take(3).join(' · ') +
                              (profileProvider.cropTypes.length > 3 ? ' +${profileProvider.cropTypes.length - 3}' : ''),
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Stats Grid ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.neumorphicCard(),
                  child: Column(
                    children: [
                      Text(
                        historyProvider.totalScans.toString(),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.totalScans,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.neumorphicCard(),
                  child: Column(
                    children: [
                      Text(
                        profileProvider.cropTypes.length.toString().padLeft(1, '0'),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.cropsTracked,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${historyProvider.totalScans > 0 ? historyProvider.successRate : 92}%',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.successRate,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Account Settings ──
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    l10n.accountSettings,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Language Toggle
                      _SettingsTile(
                        icon: Icons.language,
                        iconBgColor: AppTheme.primaryFixedDim,
                        iconColor: AppTheme.primary,
                        title: l10n.language,
                        trailing: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _LangChip(
                                label: l10n.english,
                                isActive: !localeProvider.isUrdu,
                                onTap: () => localeProvider.setLocale(
                                    const Locale('en')),
                              ),
                              const SizedBox(width: 4),
                              _LangChip(
                                label: l10n.urdu,
                                isActive: localeProvider.isUrdu,
                                onTap: () => localeProvider.setLocale(
                                    const Locale('ur')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _SettingsTile(
                        icon: Icons.nature_people,
                        iconBgColor: AppTheme.secondaryContainer,
                        iconColor: AppTheme.secondary,
                        title: l10n.farmProfile,
                        onTap: () => _navigate(const FarmProfileScreen()),
                      ),
                      const SizedBox(height: 4),
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        iconBgColor: AppTheme.secondaryContainer,
                        iconColor: AppTheme.secondary,
                        title: l10n.notificationSettings,
                        onTap: () => _navigate(const NotificationSettingsScreen()),
                      ),
                      const SizedBox(height: 4),
                      _SettingsTile(
                        icon: Icons.devices,
                        iconBgColor: AppTheme.secondaryContainer,
                        iconColor: AppTheme.secondary,
                        title: l10n.deviceSensorManagement,
                        subtitle: '${profileProvider.devices.length} device(s)',
                        onTap: () => _navigate(const DeviceManagementScreen()),
                      ),
                      const SizedBox(height: 4),
                      _SettingsTile(
                        icon: Icons.security,
                        iconBgColor: AppTheme.secondaryContainer,
                        iconColor: AppTheme.secondary,
                        title: l10n.dataPrivacy,
                        onTap: () => _navigate(const DataPrivacyScreen()),
                      ),
                      const SizedBox(height: 4),
                      _SettingsTile(
                        icon: Icons.workspace_premium,
                        iconBgColor: AppTheme.primaryFixedDim,
                        iconColor: AppTheme.primary,
                        title: l10n.subscriptionPlan,
                        subtitle: profileProvider.plan,
                        onTap: () => _navigate(const SubscriptionPlanScreen()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Logout is not implemented in this demo.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: AppTheme.error),
                    label: Text(
                      l10n.logout,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      side: BorderSide(color: AppTheme.errorContainer),
                      backgroundColor:
                          AppTheme.errorContainer.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Seasonal Insight ──
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: AppTheme.inverseSurface,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDu2NxWSVYBRS3Yp0LERK_fJCab8mrDQoTS1scwNy7bJxom8tGO1O-j7KnPQiFAZw7Zudp92MUtlg7scPOdsad9bX0QF_iH_vFr0YIosQjBQY1Thcr_tXeFz860r4VTWR8Nvcv3kfvL13Pw7BvahM6XhjVkt8qBj-UGHOsICqi5c9iY9BHwwjhAmdoAmTGZiFwLJktjynRUEJHYLvVihwCNpyF86S5kcb_cUvkeKv3fDeAj60VCTy8v4r07bCeoRr4gO7NsWe-BpDw',
                              fit: BoxFit.cover,
                              opacity: const AlwaysStoppedAnimation(0.5),
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.seasonalInsight,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                        color: AppTheme.inverseOnSurface,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.seasonalInsightBody,
                                      style: TextStyle(
                                        color: AppTheme.inverseOnSurface
                                            .withValues(alpha: 0.8),
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(Icons.chevron_right,
                      color: AppTheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
