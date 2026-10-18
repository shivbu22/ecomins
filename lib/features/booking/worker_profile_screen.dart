import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/data/models/worker_model.dart';

class WorkerProfileScreen extends ConsumerWidget {
  const WorkerProfileScreen({super.key, required this.workerId});

  final String workerId;

  static const _reviews = [
    {
      'avatar': '👩',
      'name': 'Meera N.',
      'date': '20 Oct 2024',
      'quote': 'Absolutely thorough and professional. Left my home spotless!',
      'stars': 5,
    },
    {
      'avatar': '👨',
      'name': 'Rahul G.',
      'date': '15 Oct 2024',
      'quote': 'Very punctual and eco-friendly products used. Highly recommend.',
      'stars': 5,
    },
    {
      'avatar': '👩',
      'name': 'Ananya P.',
      'date': '10 Oct 2024',
      'quote': 'Great service, very friendly and efficient.',
      'stars': 4,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WorkerModel? worker;
    try {
      worker = MockData.workers.firstWhere((w) => w.id == workerId);
    } catch (_) {}

    final name = worker?.name ?? 'Worker';
    final emoji = worker?.avatarEmoji ?? '👷';
    final rating = worker?.rating ?? 4.8;
    final certs = worker?.certifications ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Ecomins',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: const Text('👤', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat coming soon')),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking $name...')),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Book $name Now'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          // Hero section
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 52)),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Eco Cleaning Specialist',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats grid
          const Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '⭐',
                  label: 'Experience',
                  value: '8+ Years',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  emoji: '🌍',
                  label: 'Impact',
                  value: '12.4t CO₂e',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bio
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Passionate eco-cleaning specialist with 8+ years of experience. Trained in bio-enzymatic cleaning methods and committed to zero-waste practices. Certified by the Green Cleaning Institute.',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Services offered
          const Text(
            'Services Offered',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _ServiceRow(
            icon: '🧹',
            name: 'Home Cleaning',
            description: 'Full home sweep & mop',
            price: '₹299',
          ),
          const _ServiceRow(
            icon: '🧴',
            name: 'Deep Clean',
            description: 'Eco-enzymatic deep clean',
            price: '₹799',
          ),
          const _ServiceRow(
            icon: '🍳',
            name: 'Kitchen Clean',
            description: 'Appliances & countertops',
            price: '₹399',
          ),
          const SizedBox(height: 20),

          // Certifications
          if (certs.isNotEmpty) ...[
            const Text(
              'Certifications',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: certs
                  .map((c) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          c,
                          style: const TextStyle(
                              color: AppColors.onTertiaryContainer,
                              fontSize: 12),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Reviews
          const Text(
            'Reviews',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._reviews.map((r) => _ReviewCard(review: r)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.icon,
    required this.name,
    required this.description,
    required this.price,
  });

  final String icon;
  final String name;
  final String description;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Map<String, dynamic> review;

  @override
  Widget build(BuildContext context) {
    final stars = review['stars'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review['avatar'] as String,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      review['date'] as String,
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  stars,
                  (_) => const Icon(Icons.star,
                      color: Color(0xFFFFC107), size: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${review['quote']}"',
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
