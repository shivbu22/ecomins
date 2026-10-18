import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/app_bottom_nav_bar.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.phone,
                        style: const TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco, color: AppColors.primary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${user.ecoProfile.ecoPoints} pts',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Wallet Balance',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 12)),
                    Text(
                      '₹${user.wallet.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _NavTile(
            icon: Icons.edit_outlined,
            label: 'Edit Profile',
            onTap: () => context.push('/profile/edit'),
          ),
          _NavTile(
            icon: Icons.home_outlined,
            label: '🏠 Home Profile',
            onTap: () => context.push('/home-profile'),
          ),
          _NavTile(
            icon: Icons.favorite_outline,
            label: '❤️ Favourites',
            onTap: () => context.push('/favorites'),
          ),
          _NavTile(
            icon: Icons.repeat_outlined,
            label: '🔄 Recurring Bookings',
            onTap: () => context.push('/recurring'),
          ),
          _NavTile(
            icon: Icons.emoji_events_outlined,
            label: '🏆 Achievements',
            onTap: () => context.push('/profile/achievements'),
          ),
          _NavTile(
            icon: Icons.bar_chart_outlined,
            label: '📊 Spending Insights',
            onTap: () => context.push('/profile/insights'),
          ),
          _NavTile(
            icon: Icons.track_changes_outlined,
            label: '🎯 My Goals',
            onTap: () => context.push('/eco/goals'),
          ),
          _NavTile(
            icon: Icons.location_on_outlined,
            label: 'Saved Addresses',
            onTap: () => context.push('/profile/addresses'),
          ),
          _NavTile(
            icon: Icons.credit_card_outlined,
            label: 'Payment Methods',
            onTap: () => context.push('/profile/payments'),
          ),
          _NavTile(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet History',
            onTap: () => context.push('/profile/wallet'),
          ),
          _NavTile(
            icon: Icons.redeem_outlined,
            label: 'Referral Program',
            onTap: () => context.push('/profile/referral'),
          ),
          _NavTile(
            icon: Icons.workspace_premium_outlined,
            label: '💎 Subscription',
            onTap: () => context.push('/profile/subscription'),
          ),
          _NavTile(
            icon: Icons.notifications_outlined,
            label: '🔔 Notifications',
            onTap: () => context.push('/profile/notifications'),
          ),
          _NavTile(
            icon: Icons.lock_outline,
            label: '🔒 Privacy & Security',
            onTap: () => context.push('/profile/privacy'),
          ),
          _NavTile(
            icon: Icons.language_outlined,
            label: '🌐 Language & Region',
            onTap: () => context.push('/profile/language'),
          ),
          _NavTile(
            icon: Icons.emoji_events_outlined,
            label: '🏆 Loyalty Program',
            onTap: () => context.push('/profile/loyalty'),
          ),
          _NavTile(
            icon: Icons.emergency_outlined,
            label: '🆘 Emergency & Safety',
            onTap: () => context.push('/profile/emergency'),
          ),
          _NavTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => context.push('/profile/settings'),
          ),
          _NavTile(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () => context.push('/profile/help'),
          ),
          const SizedBox(height: 8),
          _NavTile(
            icon: Icons.logout,
            label: 'Sign Out',
            color: AppColors.error,
            onTap: () {
              ref.read(authStateProvider.notifier).state = false;
              context.go('/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.onSurface;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: tileColor, size: 22),
        title: Text(label, style: TextStyle(color: tileColor, fontSize: 15)),
        trailing: color == null
            ? const Icon(Icons.chevron_right, color: AppColors.outline, size: 20)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
