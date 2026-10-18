import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

/// Small chip indicating eco-friendly status.
class EcoBadgeChip extends StatelessWidget {
  const EcoBadgeChip({
    super.key,
    required this.label,
    this.isEcoFriendly = true,
  });

  final String label;
  final bool isEcoFriendly;

  @override
  Widget build(BuildContext context) {
    final color = isEcoFriendly ? AppColors.primary : AppColors.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEcoFriendly ? '🌿' : '⚪',
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
