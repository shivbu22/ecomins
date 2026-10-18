import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

/// Circular avatar with emoji, optional online indicator and border.
class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.emoji,
    this.size = 48,
    this.showOnlineDot = false,
    this.borderColor,
    this.backgroundColor,
  });

  final String emoji;
  final double size;
  final bool showOnlineDot;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppColors.surfaceContainer,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
        if (showOnlineDot)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
