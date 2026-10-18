import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/data/models/worker_model.dart';
import 'package:ecomins/shared/widgets/avatar_widget.dart';

/// Reusable worker card with avatar, name, rating, jobs, online dot, and Book button.
class WorkerCardWidget extends StatelessWidget {
  const WorkerCardWidget({
    super.key,
    required this.worker,
    this.compact = false,
    this.onTap,
  });

  final WorkerModel worker;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isOnline = worker.status == WorkerStatus.available;

    if (compact) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(12),
          decoration: AppDecorations.card(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarWidget(
                emoji: worker.avatarEmoji,
                size: 44,
                showOnlineDot: isOnline,
              ),
              const SizedBox(height: 6),
              Text(
                worker.name.split(' ').first,
                style: AppTextStyles.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFC107), size: 12),
                  const SizedBox(width: 2),
                  Text('${worker.rating}', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card(),
        child: Row(
          children: [
            AvatarWidget(
              emoji: worker.avatarEmoji,
              size: 52,
              showOnlineDot: isOnline,
              borderColor: isOnline
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(worker.name, style: AppTextStyles.h4),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 13),
                      const SizedBox(width: 3),
                      Text(worker.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall),
                      const SizedBox(width: 8),
                      Text('${worker.totalJobs} jobs',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                  if (worker.certifications.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        worker.certifications.first,
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Book',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.onPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
