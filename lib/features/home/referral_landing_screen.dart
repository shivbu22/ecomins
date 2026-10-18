import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

class ReferralLandingScreen extends StatelessWidget {
  const ReferralLandingScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('You\'ve been invited! 🎉'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: Text('🎁', style: TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your friend Arjun invited you to Ecomins',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'India\'s #1 eco-friendly home services app',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 24),
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
            child: Column(
              children: [
                const Text(
                  '🎉 Get ₹200 off your first booking!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your referral code',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Code copied to clipboard!')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          code.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy,
                            color: AppColors.primary, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Why Ecomins?',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._features.map((f) => _FeatureCard(
                emoji: f.$1,
                title: f.$2,
                subtitle: f.$3,
              )),
          const SizedBox(height: 24),
          GradientButton(
            label: 'Claim Offer & Sign Up',
            icon: Icons.arrow_forward,
            onTap: () => context.go('/login'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

const _features = [
  ('⚡', '10-Minute Service', 'Workers arrive in under 10 minutes'),
  ('🌿', 'Eco-Certified', 'All services use green products'),
  ('🏆', 'Earn Eco Points', 'Get rewarded for every booking'),
];

class _FeatureCard extends StatelessWidget {
  const _FeatureCard(
      {required this.emoji, required this.title, required this.subtitle});
  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
