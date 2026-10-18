import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

/// Displays a price with optional strikethrough original price.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.unit = 'visit',
  });

  final double price;
  final String? originalPrice;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₹${price.toStringAsFixed(0)}',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/$unit',
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            originalPrice!,
            style: const TextStyle(
              color: AppColors.outline,
              fontSize: 13,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.outline,
            ),
          ),
        ],
      ],
    );
  }
}
