import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

/// Displays star rating with optional review count.
class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.rating,
    this.reviewCount,
    this.compact = false,
  });

  final double rating;
  final int? reviewCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final starSize = compact ? 12.0 : 16.0;
    final textSize = compact ? 11.0 : 13.0;
    final filledStars = rating.floor();
    final hasHalf = (rating - filledStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < filledStars
                ? Icons.star
                : (i == filledStars && hasHalf)
                    ? Icons.star_half
                    : Icons.star_border,
            color: const Color(0xFFFFC107),
            size: starSize,
          ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: textSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: textSize,
            ),
          ),
        ],
      ],
    );
  }
}
