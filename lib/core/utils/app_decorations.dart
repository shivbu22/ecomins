import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Reusable BoxDecoration patterns used throughout the app.
class AppDecorations {
  AppDecorations._();

  /// Standard card decoration
  static BoxDecoration card({
    Color? color,
    double radius = 14,
    bool hasBorder = true,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder
            ? Border.all(color: const Color(0x1A3C4A3C))
            : null,
      );

  /// Dark gradient card (used for eco/wallet sections)
  static BoxDecoration primaryCard({double radius = 14}) => BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      );

  /// Selected state card (green tint + border)
  static BoxDecoration selectedCard({double radius = 14}) => BoxDecoration(
        color: const Color(0x1A3FE56C),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.primary, width: 1.5),
      );

  /// Card with subtle green glow shadow
  static BoxDecoration glowCard({double radius = 14}) => BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0x1A3C4A3C)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      );

  /// Surface container card (slightly elevated)
  static BoxDecoration surfaceCard({double radius = 14}) => BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
      );

  /// Pill-shaped chip decoration
  static BoxDecoration chip({
    Color? color,
    bool isSelected = false,
  }) =>
      BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.15)
            : (color ?? AppColors.surfaceContainer),
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
            : null,
      );
}
