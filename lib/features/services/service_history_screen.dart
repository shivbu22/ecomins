import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  static const _monthlyData = [
    _MonthData(month: 'May', count: 1),
    _MonthData(month: 'Jun', count: 2),
    _MonthData(month: 'Jul', count: 1),
    _MonthData(month: 'Aug', count: 3),
    _MonthData(month: 'Sep', count: 2),
    _MonthData(month: 'Oct', count: 3),
  ];

  static const _pastServices = [
    _PastService(name: 'Basic Home Cleaning', date: '24 Oct', worker: 'Ravi Kumar', amount: 449, rating: 5.0, emoji: '🧹'),
    _PastService(name: 'Daily Garbage Pickup', date: '20 Oct', worker: 'Priya Devi', amount: 499, rating: 4.5, emoji: '🗑️'),
    _PastService(name: 'Paper Recycling', date: '15 Oct', worker: 'Priya Devi', amount: 0, rating: 5.0, emoji: '📦'),
    _PastService(name: 'Garden Maintenance', date: '10 Oct', worker: 'Suresh Babu', amount: 349, rating: 4.0, emoji: '🌱'),
    _PastService(name: 'Kitchen Deep Clean', date: '5 Oct', worker: 'Ravi Kumar', amount: 399, rating: 5.0, emoji: '🍳'),
  ];

  @override
  Widget build(BuildContext context) {
    final maxCount = _monthlyData.map((m) => m.count).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Service History'),
        actions: [
          TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report downloaded!'), backgroundColor: AppColors.primary),
            ),
            icon: const Icon(Icons.download_outlined, color: AppColors.primary, size: 18),
            label: const Text('Download', style: TextStyle(color: AppColors.primary, fontSize: 13)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats row
          const Row(
            children: [
              Expanded(child: _StatCard(value: '12', label: 'Total Services', emoji: '🧹')),
              SizedBox(width: 10),
              Expanded(child: _StatCard(value: '₹4,200', label: 'Total Spent', emoji: '💰')),
              SizedBox(width: 10),
              Expanded(child: _StatCard(value: '34.5kg', label: 'CO₂ Saved', emoji: '🌿')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Monthly Breakdown', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _monthlyData.map((m) {
                      final barHeight = (m.count / maxCount) * 80;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${m.count}', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Container(
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _monthlyData.map((m) => Expanded(
                    child: Text(m.month, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10), textAlign: TextAlign.center),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Service Type Breakdown', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: Container(height: 16, color: AppColors.primary)),
                      Expanded(flex: 3, child: Container(height: 16, color: const Color(0xFF3FE56C).withValues(alpha: 0.6))),
                      Expanded(flex: 2, child: Container(height: 16, color: const Color(0xFF3FE56C).withValues(alpha: 0.3))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    _LegendItem(color: AppColors.primary, label: 'Cleaning 50%'),
                    SizedBox(width: 16),
                    _LegendItem(color: Color(0xFF3FE56C), label: 'Recycling 30%'),
                    SizedBox(width: 16),
                    _LegendItem(color: Color(0xFF1A5A30), label: 'Garden 20%'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Past Services', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._pastServices.map((s) => _PastServiceTile(service: s)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.emoji});
  final String value;
  final String label;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14)),
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _PastServiceTile extends StatelessWidget {
  const _PastServiceTile({required this.service});
  final _PastService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(service.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 14)),
                Text('${service.worker} • ${service.date}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < service.rating ? Icons.star : Icons.star_border,
                    color: AppColors.primary,
                    size: 12,
                  )),
                ),
              ],
            ),
          ),
          Text(
            service.amount > 0 ? '₹${service.amount}' : 'FREE',
            style: TextStyle(
              color: service.amount > 0 ? AppColors.onSurface : AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11)),
      ],
    );
  }
}

class _MonthData {
  const _MonthData({required this.month, required this.count});
  final String month;
  final int count;
}

class _PastService {
  const _PastService({required this.name, required this.date, required this.worker, required this.amount, required this.rating, required this.emoji});
  final String name;
  final String date;
  final String worker;
  final int amount;
  final double rating;
  final String emoji;
}
