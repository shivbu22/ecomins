import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class FlashDealsScreen extends StatefulWidget {
  const FlashDealsScreen({super.key});

  @override
  State<FlashDealsScreen> createState() => _FlashDealsScreenState();
}

class _FlashDealsScreenState extends State<FlashDealsScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _remaining;
  late AnimationController _boltController;

  final List<_Deal> _deals = const [
    _Deal(emoji: '🧹', title: 'Home Cleaning', discount: '40% off', original: '₹299', discounted: '₹179', serviceId: 'cleaning_basic'),
    _Deal(emoji: '♻️', title: 'Recycling Pickup', discount: 'FREE', original: '₹99', discounted: '₹0', serviceId: 'recycling_paper'),
    _Deal(emoji: '🌱', title: 'Garden Service', discount: '₹100 off', original: '₹349', discounted: '₹249', serviceId: 'garden_maintenance'),
    _Deal(emoji: '🧴', title: 'Deep Clean', discount: '25% off', original: '₹799', discounted: '₹599', serviceId: 'deep_full'),
  ];

  @override
  void initState() {
    super.initState();
    _remaining = const Duration(hours: 3, minutes: 45, seconds: 0);
    _boltController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
        if (_remaining.inSeconds > 0) _remaining = _remaining - const Duration(seconds: 1);
      });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _boltController.dispose();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _pad(_remaining.inHours);
    final m = _pad(_remaining.inMinutes.remainder(60));
    final s = _pad(_remaining.inSeconds.remainder(60));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _boltController,
              builder: (_, __) => Transform.scale(
                scale: 0.8 + _boltController.value * 0.4,
                child: const Text('⚡', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 6),
            const Text('Flash Deals'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Countdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A1A00), Color(0xFF1A0D00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Text('Deals expire in', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TimeChip(value: h, label: 'HRS'),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text(':', style: TextStyle(color: Color(0xFFFFB347), fontSize: 24, fontWeight: FontWeight.w800))),
                    _TimeChip(value: m, label: 'MIN'),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text(':', style: TextStyle(color: Color(0xFFFFB347), fontSize: 24, fontWeight: FontWeight.w800))),
                    _TimeChip(value: s, label: 'SEC'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._deals.map((d) => _DealCard(deal: d)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All deals loaded!'), backgroundColor: AppColors.primary),
              ),
              child: const Text('View All Deals', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Color(0xFFFFB347), fontSize: 24, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
      ],
    );
  }
}

class _DealCard extends StatelessWidget {
  const _DealCard({required this.deal});
  final _Deal deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(deal.emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deal.title, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(deal.original, style: const TextStyle(color: AppColors.outline, fontSize: 12, decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 6),
                    Text(deal.discounted, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(deal.discount, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => context.push('/book/${deal.serviceId}'),
                child: const Text('Claim', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Deal {
  const _Deal({required this.emoji, required this.title, required this.discount, required this.original, required this.discounted, required this.serviceId});
  final String emoji;
  final String title;
  final String discount;
  final String original;
  final String discounted;
  final String serviceId;
}
