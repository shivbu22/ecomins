import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/app_bottom_nav_bar.dart';
import 'package:ecomins/shared/widgets/avatar_widget.dart';
import 'package:ecomins/shared/widgets/status_chip.dart';

/// Redesigned Profile v2 with grouped menu sections.
class ProfileV2Screen extends ConsumerWidget {
  const ProfileV2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final eco = user.ecoProfile;
    final tier = AppUtils.ecoTier(eco.ecoPoints);
    final tierColor = AppUtils.ecoTierColor(eco.ecoPoints);
    final tierEmoji = AppUtils.ecoTierEmoji(eco.ecoPoints);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Text('Profile', style: AppTextStyles.h3),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Header: avatar + name + tier ────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.primaryCard(radius: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    AvatarWidget(
                      emoji: '👤',
                      size: 64,
                      showOnlineDot: true,
                      borderColor: tierColor.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTextStyles.h3),
                          const SizedBox(height: 2),
                          Text(AppUtils.formatPhone(user.phone),
                              style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          StatusChip(
                            label: tier,
                            color: tierColor,
                            emoji: tierEmoji,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/profile/edit'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: AppColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    _StatItem(
                        value: '${MockData.bookings.length}',
                        label: 'Bookings'),
                    _StatItem(
                        value: '${eco.co2SavedKg.toStringAsFixed(1)}kg',
                        label: 'CO₂ Saved'),
                    _StatItem(
                        value: '${eco.carbonCredits}',
                        label: 'Trees'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Wallet card ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.card(),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet Balance', style: AppTextStyles.bodySmall),
                      Text(
                        AppUtils.formatCurrency(user.wallet.balance),
                        style: AppTextStyles.price,
                      ),
                    ],
                  ),
                ),
                _WalletButton(
                  label: 'Add Money',
                  onTap: () => context.push('/profile/wallet/topup'),
                ),
                const SizedBox(width: 8),
                _WalletButton(
                  label: 'History',
                  onTap: () => context.push('/profile/wallet'),
                  outlined: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Menu sections ────────────────────────────────────────────
          const _MenuSection(
            title: 'My Account',
            items: [
              _MenuItem(icon: Icons.edit_outlined, label: 'Edit Profile', route: '/profile/edit'),
              _MenuItem(icon: Icons.home_outlined, label: 'Home Profile', route: '/home-profile'),
              _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses', route: '/profile/addresses'),
              _MenuItem(icon: Icons.credit_card_outlined, label: 'Payment Methods', route: '/profile/payments'),
            ],
          ),
          const _MenuSection(
            title: 'Services',
            items: [
              _MenuItem(icon: Icons.favorite_outline, label: 'Favourites', route: '/favorites'),
              _MenuItem(icon: Icons.repeat_outlined, label: 'Recurring Bookings', route: '/recurring'),
              _MenuItem(icon: Icons.alarm_outlined, label: 'Reminders', route: '/reminders'),
              _MenuItem(icon: Icons.history_outlined, label: 'Service History', route: '/service-history'),
            ],
          ),
          const _MenuSection(
            title: 'Eco',
            items: [
              _MenuItem(icon: Icons.track_changes_outlined, label: 'Goals', route: '/eco/goals'),
              _MenuItem(icon: Icons.emoji_events_outlined, label: 'Achievements', route: '/profile/achievements'),
              _MenuItem(icon: Icons.military_tech_outlined, label: 'Badges', route: '/eco/badges'),
              _MenuItem(icon: Icons.flag_outlined, label: 'Challenges', route: '/eco/challenges'),
            ],
          ),
          const _MenuSection(
            title: 'Wallet & Payments',
            items: [
              _MenuItem(icon: Icons.account_balance_wallet_outlined, label: 'Wallet', route: '/profile/wallet'),
              _MenuItem(icon: Icons.receipt_outlined, label: 'Transactions', route: '/profile/wallet'),
              _MenuItem(icon: Icons.workspace_premium_outlined, label: 'Subscription', route: '/profile/subscription'),
            ],
          ),
          const _MenuSection(
            title: 'Support',
            items: [
              _MenuItem(icon: Icons.help_outline, label: 'Help & Support', route: '/profile/help'),
              _MenuItem(icon: Icons.confirmation_number_outlined, label: 'Raise Ticket', route: '/profile/ticket'),
              _MenuItem(icon: Icons.quiz_outlined, label: 'FAQ', route: '/services/faq'),
            ],
          ),
          const _MenuSection(
            title: 'Settings',
            items: [
              _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', route: '/profile/notifications'),
              _MenuItem(icon: Icons.lock_outline, label: 'Privacy', route: '/profile/privacy'),
              _MenuItem(icon: Icons.language_outlined, label: 'Language', route: '/profile/language'),
              _MenuItem(icon: Icons.security_outlined, label: 'Security', route: '/profile/security'),
            ],
          ),
          const _MenuSection(
            title: 'Referral & Rewards',
            items: [
              _MenuItem(icon: Icons.share_outlined, label: 'Referral Program', route: '/profile/referral'),
              _MenuItem(icon: Icons.loyalty_outlined, label: 'Loyalty Program', route: '/profile/loyalty'),
              _MenuItem(icon: Icons.card_giftcard_outlined, label: 'Gift Cards', route: '/gift-cards'),
            ],
          ),

          // Sign out
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              ref.read(authStateProvider.notifier).state = false;
              context.go('/login');
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.errorContainer.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.error, size: 20),
                  const SizedBox(width: 12),
                  Text('Sign Out',
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.error)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              )),
          Text(label,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 11)),
        ],
      ),
    );
  }
}

class _WalletButton extends StatelessWidget {
  const _WalletButton({
    required this.label,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          border: outlined
              ? Border.all(color: AppColors.primary)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: outlined ? AppColors.primary : AppColors.onPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});

  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title,
              style: AppTextStyles.label.copyWith(
                  color: AppColors.onSurfaceVariant)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x1A3C4A3C)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon,
                        color: AppColors.onSurfaceVariant, size: 20),
                    title: Text(item.label, style: AppTextStyles.body),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.outline, size: 18),
                    onTap: () => context.push(item.route),
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  if (i < items.length - 1)
                    const Divider(
                        height: 1,
                        indent: 52,
                        color: Color(0x1A3C4A3C)),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}
