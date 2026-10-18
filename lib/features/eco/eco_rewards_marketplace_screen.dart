import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/eco_model.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/providers/eco_providers.dart';

class EcoRewardsMarketplaceScreen extends ConsumerStatefulWidget {
  const EcoRewardsMarketplaceScreen({super.key});

  @override
  ConsumerState<EcoRewardsMarketplaceScreen> createState() =>
      _EcoRewardsMarketplaceScreenState();
}

class _EcoRewardsMarketplaceScreenState
    extends ConsumerState<EcoRewardsMarketplaceScreen> {
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Vouchers', 'Products', 'Experiences', 'Donations'];

  static const _filterToType = {
    'Vouchers': RewardType.voucher,
    'Products': RewardType.product,
    'Experiences': RewardType.experience,
    'Donations': RewardType.donation,
  };

  List<EcoReward> _filtered(List<EcoReward> rewards) {
    if (_selectedFilter == 'All') return rewards;
    final type = _filterToType[_selectedFilter];
    return rewards.where((r) => r.type == type).toList();
  }

  String _typeLabel(RewardType t) {
    switch (t) {
      case RewardType.voucher:
        return 'Voucher';
      case RewardType.product:
        return 'Product';
      case RewardType.experience:
        return 'Experience';
      case RewardType.donation:
        return 'Donation';
    }
  }

  void _showRewardSheet(BuildContext context, EcoReward reward, int userPoints) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(reward.imageEmoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              reward.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reward.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${reward.pointsCost} Eco Points',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  if (userPoints < reward.pointsCost) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Insufficient points! Need ${reward.pointsCost - userPoints} more.'),
                        backgroundColor: AppColors.errorContainer,
                      ),
                    );
                    return;
                  }
                  try {
                    final user = ref.read(currentUserProvider);
                    await ref
                        .read(ecoRepositoryProvider)
                        .redeemReward(user.uid, reward);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${reward.title} redeemed!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Redeem for ${reward.pointsCost} pts'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final userPoints = user.ecoProfile.ecoPoints;
    final allRewards = ref.watch(rewardsProvider);
    final filtered = _filtered(allRewards);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Eco Rewards'),
      ),
      body: Column(
        children: [
          // Balance card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                const Text('🌿', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Eco Points',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                    Text(
                      '$userPoints pts',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final f = _filters[index];
                final selected = _selectedFilter == f;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Grid
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎁', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'No $_selectedFilter rewards yet',
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final reward = filtered[index];
                      final canAfford = userPoints >= reward.pointsCost;
                      return GestureDetector(
                        onTap: () =>
                            _showRewardSheet(context, reward, userPoints),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14)),
                                ),
                                child: Center(
                                  child: Text(reward.imageEmoji,
                                      style:
                                          const TextStyle(fontSize: 40)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _typeLabel(reward.type),
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      reward.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.onSurface,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${reward.pointsCost} pts',
                                      style: TextStyle(
                                        color: canAfford
                                            ? AppColors.primary
                                            : AppColors.error,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
