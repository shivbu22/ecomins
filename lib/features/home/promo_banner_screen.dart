import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class PromoBannerScreen extends StatefulWidget {
  const PromoBannerScreen({super.key});

  @override
  State<PromoBannerScreen> createState() => _PromoBannerScreenState();
}

class _PromoBannerScreenState extends State<PromoBannerScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _remaining;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final sunday = now.add(Duration(days: (7 - now.weekday) % 7 == 0 ? 7 : (7 - now.weekday) % 7));
    final sundayMidnight = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
    _remaining = sundayMidnight.difference(now);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (_remaining.inSeconds > 0) {
            _remaining = _remaining - const Duration(seconds: 1);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _shimmerController.dispose();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _pad(_remaining.inHours);
    final m = _pad(_remaining.inMinutes.remainder(60));
    final s = _pad(_remaining.inSeconds.remainder(60));

    return Scaffold(
      body: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(const Color(0xFF0D2E1A), const Color(0xFF1A5A30), _shimmerController.value)!,
                  Color.lerp(const Color(0xFF111411), const Color(0xFF0D2E1A), _shimmerController.value)!,
                  Color.lerp(const Color(0xFF1A5A30), const Color(0xFF0D2E1A), _shimmerController.value)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 24),
                const Text(
                  'Weekend Special',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  '30% off all cleaning services',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Offer ends in',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TimeBox(value: h, label: 'HRS'),
                    const _Colon(),
                    _TimeBox(value: m, label: 'MIN'),
                    const _Colon(),
                    _TimeBox(value: s, label: 'SEC'),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => context.go('/services/cleaning'),
                    child: const Text('Claim Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Maybe Later', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
        ],
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(':', style: TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w800)),
    );
  }
}
