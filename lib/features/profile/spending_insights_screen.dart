import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class SpendingInsightsScreen extends StatelessWidget {
  const SpendingInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const monthlyData = [
      ('May', 800.0),
      ('Jun', 1050.0),
      ('Jul', 920.0),
      ('Aug', 1100.0),
      ('Sep', 980.0),
      ('Oct', 1248.0),
    ];
    const maxVal = 1248.0;

    const categories = [
      ('🧹', 'Cleaning', 0.45, 562.0),
      ('🗑️', 'Garbage', 0.25, 312.0),
      ('♻️', 'Recycling', 0.20, 249.0),
      ('🌱', 'Garden', 0.10, 125.0),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Spending Insights 📊'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // This month
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('This Month',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
                Text('₹1,248',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.arrow_upward,
                        color: AppColors.error, size: 14),
                    Text('12% vs last month',
                        style: TextStyle(
                            color: AppColors.error, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bar chart
          const Text('Monthly Trend',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthlyData.map((item) {
                final frac = item.$2 / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 90 * frac,
                          decoration: BoxDecoration(
                            color: item.$1 == 'Oct'
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(item.$1,
                            style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 10)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Category breakdown
          const Text('Category Breakdown',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(cat.$1,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(cat.$2,
                            style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(
                          '${(cat.$3 * 100).toStringAsFixed(0)}% · ₹${cat.$4.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: cat.$3,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Highlights
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('🏆', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Most used service',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12)),
                  ],
                ),
                SizedBox(height: 4),
                Text('Basic Home Cleaning (8 times)',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('💰', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Biggest saving',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12)),
                  ],
                ),
                SizedBox(height: 4),
                Text('₹320 saved via eco discounts',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Statement download started...')),
              );
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download Statement'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
