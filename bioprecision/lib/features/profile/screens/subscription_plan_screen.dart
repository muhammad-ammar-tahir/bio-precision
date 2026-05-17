import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/user_profile_provider.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({super.key});

  Future<void> _selectPlan(BuildContext context, String plan) async {
    final profile = context.read<UserProfileProvider>();
    if (plan == 'Pro Plan') {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(children: [
            Icon(Icons.workspace_premium, color: AppTheme.primary),
            const SizedBox(width: 8),
            const Text('Already on Pro!', style: TextStyle(fontWeight: FontWeight.w800)),
          ]),
          content: const Text(
            'You are already on the best plan – no changes made. Enjoy all premium features!',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Great!', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Downgrade to Free?', style: TextStyle(fontWeight: FontWeight.w800)),
          content: const Text(
            'Downgrading to the Free plan will limit AI scans to 5 per month and remove advanced analytics. Are you sure?',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Downgrade', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        await profile.setPlan('Free Plan');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Plan changed to Free.'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileProvider>();
    final isPro = profile.plan == 'Pro Plan';

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Subscription Plan'),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Current plan badge
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.leafGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.white, size: 36),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Plan',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12)),
                    Text(profile.plan,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text('Change Plan',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: AppTheme.primary)),
          const SizedBox(height: 16),

          // Free plan tile
          _PlanTile(
            name: 'Free Plan',
            price: 'Free',
            features: const [
              '5 AI scans per month',
              'Basic disease detection',
              'No analytics dashboard',
            ],
            isSelected: !isPro,
            onTap: () => _selectPlan(context, 'Free Plan'),
          ),
          const SizedBox(height: 16),

          // Pro plan tile
          _PlanTile(
            name: 'Pro Plan',
            price: '\$4.99/mo',
            features: const [
              'Unlimited AI scans',
              'Advanced disease analytics',
              'Weather integration',
              'Export scan reports',
              'Priority support',
            ],
            isSelected: isPro,
            onTap: () => _selectPlan(context, 'Pro Plan'),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;
  final bool highlight;

  const _PlanTile({
    required this.name,
    required this.price,
    required this.features,
    required this.isSelected,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryFixedDim.withValues(alpha: 0.3)
              : AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? AppTheme.primary : AppTheme.onSurface)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                            fontSize: 16)),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: const Text('Current',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16,
                          color: isSelected ? AppTheme.primary : AppTheme.outlineVariant),
                      const SizedBox(width: 8),
                      Text(f,
                          style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? AppTheme.onSurface
                                  : AppTheme.onSurfaceVariant)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
