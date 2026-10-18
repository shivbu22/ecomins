import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

class TransactionDetailsScreen extends ConsumerStatefulWidget {
  const TransactionDetailsScreen({super.key, required this.txId});

  final String txId;

  @override
  ConsumerState<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState
    extends ConsumerState<TransactionDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? tx;
    try {
      tx = MockData.transactions.firstWhere((t) => t['id'] == widget.txId);
    } catch (_) {}

    final isCredit = (tx?['type'] ?? 'credit') == 'credit';
    final amount = (tx?['amount'] as double?) ?? 0.0;
    final description = (tx?['description'] as String?) ?? 'Transaction';
    final date = (tx?['date'] as String?) ?? '';
    final co2 = (tx?['co2'] as double?) ?? 0.0;
    final txId = tx?['id'] as String? ?? widget.txId;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'ECO-FLOW',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Center header
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.15),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 2),
                  ),
                  child: const Center(
                    child: Text('🌿', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${isCredit ? '+' : '-'} ${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isCredit ? AppColors.primary : AppColors.error,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'EMERALD COINS',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bento grid
          Row(
            children: [
              Expanded(
                child: _BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (_, __) => Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary
                                    .withValues(alpha: _pulseAnimation.value),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Completed',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Transaction ID (full width)
          _BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction ID',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        txId,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined,
                          color: AppColors.primary, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: txId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Transaction ID copied!')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Environmental impact (full width)
          if (co2 > 0)
            _BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Environmental Impact',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('🌿', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '-${co2.toStringAsFixed(1)} kg CO₂ Offset',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt downloaded!')),
              ),
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Download Receipt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impact card shared!')),
              ),
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Share Impact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceContainer,
                foregroundColor: AppColors.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.location_city_outlined,
                      size: 48, color: AppColors.outline),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: const Text(
                      'Metro Recycling Hub Central',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
