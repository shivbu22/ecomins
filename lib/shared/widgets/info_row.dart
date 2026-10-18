import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';

/// Consistent icon + label + value row used in detail screens.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? AppColors.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: valueColor ?? AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
