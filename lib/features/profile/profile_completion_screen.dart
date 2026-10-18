import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/extensions.dart';

/// Profile completion flow shown after first login.
class ProfileCompletionScreen extends ConsumerWidget {
  const ProfileCompletionScreen({super.key});

  static const _steps = [
    _CompletionStep(
      emoji: '📸',
      title: 'Add a photo',
      subtitle: 'Help workers recognize you',
      route: '/profile/edit',
      points: 20,
    ),
    _CompletionStep(
      emoji: '📍',
      title: 'Add your address',
      subtitle: 'For faster service booking',
      route: '/profile/addresses/add',
      points: 30,
    ),
    _CompletionStep(
      emoji: '🏠',
      title: 'Set home profile',
      subtitle: 'Get personalized recommendations',
      route: '/home-profile',
      points: 30,
    ),
    _CompletionStep(
      emoji: '🔔',
      title: 'Enable notifications',
      subtitle: 'Stay updated on your bookings',
      route: '/profile/notifications',
      points: 20,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock: 2 of 4 steps completed
    const completedCount = 2;
    const totalSteps = 4;
    const progress = completedCount / totalSteps;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Text('Complete Your Profile', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.primaryCard(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your profile is ${(progress * 100).toInt()}% complete',
                        style: AppTextStyles.h4.copyWith(
                            color: AppColors.primary),
                      ),
                    ),
                    Text(
                      '$completedCount/$totalSteps',
                      style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete all steps to earn 100 🌿 eco points!',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Steps
          ..._steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isCompleted = i < completedCount;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: isCompleted
                  ? AppDecorations.selectedCard()
                  : AppDecorations.card(),
              child: Row(
                children: [
                  Text(step.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title, style: AppTextStyles.h4),
                        Text(step.subtitle, style: AppTextStyles.bodySmall),
                        const SizedBox(height: 4),
                        Text('+${step.points} pts',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    const Icon(Icons.check_circle,
                        color: AppColors.primary, size: 24)
                  else
                    GestureDetector(
                      onTap: () => context.push(step.route),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Add',
                            style: AppTextStyles.label.copyWith(
                                color: AppColors.onPrimary)),
                      ),
                    ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              context.showSnack('You can complete this later from your profile');
              context.go('/home');
            },
            child: Center(
              child: Text(
                'Complete Later',
                style: AppTextStyles.body.copyWith(
                    color: AppColors.outline,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.outline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionStep {
  const _CompletionStep({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.points,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String route;
  final int points;
}
