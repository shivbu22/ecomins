import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

const _ratingBreakdown = [
  (5, 0.72),
  (4, 0.18),
  (3, 0.06),
  (2, 0.02),
  (1, 0.02),
];

const _keywords = [
  'Professional',
  'Eco-friendly',
  'Punctual',
  'Thorough',
  'Friendly',
];

class ServiceRatingSummaryScreen extends StatelessWidget {
  const ServiceRatingSummaryScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Service Ratings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall rating
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Column(
                  children: [
                    Text(
                      '4.8',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                        Icon(Icons.star_half,
                            color: Color(0xFFFFC107), size: 18),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Based on 2,340 reviews',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: _ratingBreakdown.map((r) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text('${r.$1}★',
                                style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _AnimatedBar(percent: r.$2),
                            ),
                            const SizedBox(width: 6),
                            Text(
                                '${(r.$2 * 100).toInt()}%',
                                style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Top Keywords',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _keywords.map((k) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  k,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Photos',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 6,
            itemBuilder: (context, i) {
              const emojis = ['🧹', '🏠', '✨', '🌿', '🧴', '🪣'];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(emojis[i],
                      style: const TextStyle(fontSize: 32)),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showReviewSheet(context),
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('Write a Review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context) {
    final ctrl = TextEditingController();
    int stars = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Write a Review',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setS(() => stars = i + 1),
                    child: Icon(
                      i < stars ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFC107),
                      size: 36,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                maxLines: 4,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  hintStyle: const TextStyle(
                      color: AppColors.onSurfaceVariant),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Review submitted! Thank you.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedBar extends StatelessWidget {
  const _AnimatedBar({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: percent,
        backgroundColor: AppColors.surfaceContainerLow,
        valueColor:
            const AlwaysStoppedAnimation<Color>(AppColors.primary),
        minHeight: 6,
      ),
    );
  }
}
