import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_spacing.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/features/home/widgets/active_booking_banner.dart';
import 'package:ecomins/features/home/widgets/eco_impact_card.dart';
import 'package:ecomins/features/home/widgets/hero_banner.dart';
import 'package:ecomins/features/home/widgets/live_status_chip.dart';
import 'package:ecomins/features/home/widgets/promo_banner_widget.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/providers/location_providers.dart';
import 'package:ecomins/providers/notification_providers.dart';
import 'package:ecomins/providers/service_providers.dart';
import 'package:ecomins/shared/widgets/app_bottom_nav_bar.dart';
import 'package:ecomins/shared/widgets/countdown_timer.dart';
import 'package:ecomins/shared/widgets/loading_shimmer.dart';
import 'package:ecomins/shared/widgets/section_header.dart';
import 'package:ecomins/shared/widgets/service_category_card.dart';

/// Production home screen with CustomScrollView + SliverAppBar.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);
    final categories = ref.watch(serviceCategoriesProvider);
    final nearbyWorkers = ref.watch(nearbyWorkersProvider(''));
    final selectedCity = ref.watch(selectedCityProvider);
    final user = ref.watch(currentUserProvider);
    final activeBooking = MockData.bookings
        .where((b) => b.status == BookingStatus.workerAssigned)
        .firstOrNull;

    final deliveryEnd = DateTime.now().add(const Duration(minutes: 10));
    final firstName = user.name.split(' ').first;
    final greeting = AppUtils.greeting();
    final greetingEmoji = AppUtils.greetingEmoji();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          // ── Blurred SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 0,
            toolbarHeight: 60,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: const Color(0xBB111411),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Location chip
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/city'),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: AppColors.primary, size: 18),
                                  const SizedBox(width: 4),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Delivering to',
                                          style: AppTextStyles.caption),
                                      Row(
                                        children: [
                                          Text(selectedCity,
                                              style: AppTextStyles.bodyMedium),
                                          const SizedBox(width: 2),
                                          const Icon(Icons.keyboard_arrow_down,
                                              color: AppColors.onSurface, size: 16),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Notification bell with badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined,
                                    color: AppColors.onSurface),
                                onPressed: () => context.push('/notifications'),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      unreadCount > 9 ? '9+' : '$unreadCount',
                                      style: const TextStyle(
                                        color: AppColors.onError,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    '$greeting, $firstName $greetingEmoji',
                    style: AppTextStyles.h2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Text(
                    'What eco service do you need today?',
                    style: AppTextStyles.bodySmall,
                  ),
                ),

                // ── Active booking banner ────────────────────────────────
                if (activeBooking != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ActiveBookingBanner(booking: activeBooking),
                  ),

                // ── Promo banner ─────────────────────────────────────────
                const PromoBannerWidget(),

                // ── Search bar ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x333C4A3C)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.outline, size: 20),
                          const SizedBox(width: 8),
                          Text('Search for eco services...',
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.outline)),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Hero banner ──────────────────────────────────────────
                HeroBanner(
                  firstCategoryId: categories.isNotEmpty ? categories.first.id : null,
                ),

                // ── 10-min countdown ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        const Text('⚡', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Next worker arrives in',
                              style: AppTextStyles.body),
                        ),
                        CountdownTimer(
                          endTime: deliveryEnd,
                          style: AppTextStyles.h4.copyWith(
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Live status chip ─────────────────────────────────────
                LiveStatusChip(workerCount: nearbyWorkers.length),
                AppSpacing.gapMd,

                // ── Quick action chips ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _QuickChip(label: '⚡ Flash Deals', onTap: () => context.push('/flash-deals')),
                        AppSpacing.hGapSm,
                        _QuickChip(label: '🔄 Quick Rebook', onTap: () => context.push('/quick-rebook')),
                        AppSpacing.hGapSm,
                        _QuickChip(label: '🗺️ Near Me', onTap: () => context.push('/service-map')),
                        AppSpacing.hGapSm,
                        _QuickChip(label: '📦 Bundles', onTap: () => context.push('/bundles')),
                        AppSpacing.hGapSm,
                        _QuickChip(label: '🎁 Gift Cards', onTap: () => context.push('/gift-cards')),
                        AppSpacing.hGapSm,
                        _QuickChip(label: '🌸 Seasonal', onTap: () => context.push('/seasonal')),
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapXl,

                // ── For You section ──────────────────────────────────────
                SectionHeader(
                  title: 'For You, $firstName',
                  actionLabel: 'See all',
                  onAction: () => context.push('/for-you'),
                ),
                AppSpacing.gapMd,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PersonalizedCard(
                          emoji: '🧹',
                          title: 'Home Cleaning',
                          subtitle: 'Your most booked',
                          onTap: () => context.push('/book/cleaning_basic'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PersonalizedCard(
                          emoji: '♻️',
                          title: 'Paper Recycling',
                          subtitle: 'Earn 50 🌿 pts',
                          onTap: () => context.push('/book/recycling_paper'),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapXl,

                // ── Quick Rebook ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => context.push('/quick-rebook'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: AppDecorations.card(),
                      child: Row(
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rebook your last service',
                                    style: AppTextStyles.h4),
                                Text('Home Cleaning · Ravi Kumar',
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Rebook',
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.onPrimary)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapXl,

                // ── Service categories ───────────────────────────────────
                SectionHeader(
                  title: 'Our Services',
                  actionLabel: 'All services',
                  onAction: () => context.push('/services/all'),
                ),
                AppSpacing.gapMd,
                categories.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: 6,
                          itemBuilder: (_, __) => const ShimmerBox(
                            width: double.infinity,
                            height: 100,
                            borderRadius: 12,
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount =
                              constraints.maxWidth >= 600 ? 3 : 2;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return ServiceCategoryCard(
                                  category: category,
                                  onTap: () =>
                                      context.push('/services/${category.id}'),
                                );
                              },
                            ),
                          );
                        },
                      ),
                AppSpacing.gapXxl,

                // ── Featured Workers ─────────────────────────────────────
                SectionHeader(
                  title: 'Featured Workers',
                  actionLabel: 'See all',
                  onAction: () => context.push('/workers/nearby'),
                ),
                AppSpacing.gapMd,
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: nearbyWorkers.take(5).length,
                    itemBuilder: (context, i) {
                      final w = nearbyWorkers[i];
                      return GestureDetector(
                        onTap: () => context.push('/worker/${w.id}'),
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: AppDecorations.card(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Text(w.avatarEmoji,
                                      style: const TextStyle(fontSize: 28)),
                                  Positioned(
                                    bottom: -2,
                                    right: -4,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.background,
                                            width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                w.name.split(' ').first,
                                style: AppTextStyles.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star,
                                      color: Color(0xFFFFC107), size: 12),
                                  const SizedBox(width: 2),
                                  Text('${w.rating}',
                                      style: AppTextStyles.caption),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AppSpacing.gapXxl,

                // ── Eco Impact Today ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EcoImpactCard(
                    onTap: () => context.push('/eco/impact'),
                  ),
                ),
                AppSpacing.gapXxxl,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Text(label, style: AppTextStyles.chip),
      ),
    );
  }
}

class _PersonalizedCard extends StatelessWidget {
  const _PersonalizedCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji, title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(title, style: AppTextStyles.h4),
            Text(subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
