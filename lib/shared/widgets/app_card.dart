import 'package:flutter/material.dart';

import 'package:ecomins/core/utils/app_decorations.dart';

/// Reusable card widget with consistent styling.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.radius = 14,
    this.hasBorder = true,
    this.hasGlow = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double radius;
  final bool hasBorder;
  final bool hasGlow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = hasGlow
        ? AppDecorations.glowCard(radius: radius)
        : AppDecorations.card(color: color, radius: radius, hasBorder: hasBorder);

    final content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: child,
    );

    if (onTap == null) return content;

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}
