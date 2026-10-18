import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class ReferralProgramScreen extends ConsumerWidget {
  const ReferralProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const referralCode = 'ECO-ARJUN-2024';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Referral Program'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Hero
          const Text(
            'Refer & Earn',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get ₹100 for every friend who books their first service',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
          ),
          const SizedBox(height: 24),

          // Stats row
          const Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '👥',
                  value: '3',
                  label: 'Friends Referred',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  emoji: '💰',
                  value: '₹300',
                  label: 'Total Earned',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Referral code card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3), width: 1),
            ),
            child: Column(
              children: [
                const Text(
                  'Your Referral Code',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 12),
                const Text(
                  referralCode,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                        const ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Referral code copied!')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy Code'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Share button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing referral link...')),
              ),
              icon: const Icon(Icons.share),
              label: const Text('Share with Friends'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // How it works
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: TextStyle(
                    color: AppColors.onTertiaryContainer,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                _HowItWorksStep(
                  step: '1',
                  icon: '📤',
                  text: 'Share your unique referral code with friends',
                ),
                _HowItWorksStep(
                  step: '2',
                  icon: '📱',
                  text: 'Friend signs up using your code',
                ),
                _HowItWorksStep(
                  step: '3',
                  icon: '✅',
                  text: 'Friend completes their first booking',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
  });

  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  const _HowItWorksStep({
    required this.step,
    required this.icon,
    required this.text,
  });

  final String step;
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: AppColors.onTertiaryContainer, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
