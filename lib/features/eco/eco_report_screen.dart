import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EcoReportScreen extends StatefulWidget {
  const EcoReportScreen({super.key});

  @override
  State<EcoReportScreen> createState() => _EcoReportScreenState();
}

class _EcoReportScreenState extends State<EcoReportScreen> {
  int _monthOffset = 0;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _monthLabel {
    final now = DateTime.now();
    final d = DateTime(now.year, now.month - _monthOffset);
    return '${_months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Monthly Eco Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report shared!')),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.onSurface),
                onPressed: () =>
                    setState(() => _monthOffset++),
              ),
              Text(
                _monthLabel,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right,
                    color: AppColors.onSurface),
                onPressed: _monthOffset > 0
                    ? () => setState(() => _monthOffset--)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    _StatCard(emoji: '🌿', value: '12.4 kg', label: 'CO₂ Saved'),
                    SizedBox(width: 12),
                    _StatCard(emoji: '📦', value: '8', label: 'Services'),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _StatCard(emoji: '⭐', value: '320', label: 'Eco Points'),
                    SizedBox(width: 12),
                    _StatCard(emoji: '🌳', value: '1.6', label: 'Trees Equiv.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Service Breakdown',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._breakdown.map((b) => _BreakdownBar(
                label: b.$1,
                percent: b.$2,
                color: b.$3,
              )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('📈', style: TextStyle(fontSize: 24)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'vs Last Month',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.arrow_upward,
                              color: AppColors.primary, size: 14),
                          Text(
                            ' 23% more CO₂ saved',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Downloading report...')),
            ),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download Report'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

const _breakdown = [
  ('🧹 Cleaning', 0.45, AppColors.primary),
  ('🗑️ Garbage', 0.25, Color(0xFFFF8D81)),
  ('♻️ Recycling', 0.20, Color(0xFF64B5F6)),
  ('🌱 Garden', 0.10, Color(0xFFA5D6A7)),
];

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.emoji, required this.value, required this.label});
  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
            Text(label,
                style: const TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _BreakdownBar extends StatelessWidget {
  const _BreakdownBar(
      {required this.label, required this.percent, required this.color});
  final String label;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.onSurface, fontSize: 13)),
              Text('${(percent * 100).toInt()}%',
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.surfaceContainerLow,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
