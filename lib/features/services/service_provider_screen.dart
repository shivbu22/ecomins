import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

const _extraWorkers = [
  ('👩', 'Kavitha Nair', 'Eco Specialist', 4.9, 412),
  ('👨', 'Mohan Das', 'Garden Expert', 4.6, 98),
];

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Our Service Providers'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Row(
            children: [
              _StatBadge(value: '500+', label: 'Verified'),
              SizedBox(width: 12),
              _StatBadge(value: '4.8★', label: 'Avg Rating'),
              SizedBox(width: 12),
              _StatBadge(value: '10K+', label: 'Services'),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Top Rated', 'Nearby', 'New'].map((f) {
                final sel = _filter == f;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: sel
                            ? AppColors.onPrimary
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ...MockData.workers.map((w) => _ProviderCard(
                emoji: w.avatarEmoji,
                name: w.name,
                specialization: w.certifications.isNotEmpty
                    ? w.certifications.first
                    : 'General',
                rating: w.rating,
                jobs: w.totalJobs,
                onView: () => context.push('/worker/${w.id}'),
              )),
          ..._extraWorkers.map((e) => _ProviderCard(
                emoji: e.$1,
                name: e.$2,
                specialization: e.$3,
                rating: e.$4,
                jobs: e.$5,
                onView: () {},
              )),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showBecomeProviderSheet(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Text('🌿', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Become a Provider',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Earn money while helping the planet',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColors.primary, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBecomeProviderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌿', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            const Text(
              'Join Ecomins as a Provider',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Earn ₹500–₹2000/day. Flexible hours. Eco-certified training provided.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
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

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.emoji,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.jobs,
    required this.onView,
  });

  final String emoji;
  final String name;
  final String specialization;
  final double rating;
  final int jobs;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
                Text(specialization,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Color(0xFFFFC107), size: 14),
                    const SizedBox(width: 2),
                    Text('$rating',
                        style: const TextStyle(
                            color: AppColors.onSurface, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text('$jobs jobs',
                        style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onView,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
