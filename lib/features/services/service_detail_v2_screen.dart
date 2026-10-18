import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/data/models/service_model.dart';
import 'package:ecomins/providers/personalization_providers.dart';
import 'package:ecomins/providers/service_providers.dart';
import 'package:ecomins/shared/widgets/status_chip.dart';

/// Completely redesigned service detail with tabs: Overview | Packages | Reviews | FAQs
class ServiceDetailV2Screen extends ConsumerStatefulWidget {
  const ServiceDetailV2Screen({
    super.key,
    required this.categoryId,
    required this.serviceId,
  });

  final String categoryId;
  final String serviceId;

  @override
  ConsumerState<ServiceDetailV2Screen> createState() =>
      _ServiceDetailV2ScreenState();
}

class _ServiceDetailV2ScreenState
    extends ConsumerState<ServiceDetailV2Screen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(serviceByIdProvider(widget.serviceId));
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(widget.serviceId);

    if (service == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background),
        body: Center(
          child: Text('Service not found', style: AppTextStyles.bodySmall),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.onSurface,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppColors.onSurface,
                ),
                onPressed: () {
                  final notifier = ref.read(favoritesProvider.notifier);
                  final current =
                      Set<String>.from(ref.read(favoritesProvider));
                  if (isFavorite) {
                    current.remove(widget.serviceId);
                  } else {
                    current.add(widget.serviceId);
                  }
                  notifier.state = current;
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(service.iconAsset,
                          style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(service.name,
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 14),
                          const SizedBox(width: 4),
                          Text(service.avgRating.toStringAsFixed(1),
                              style: AppTextStyles.bodySmall),
                          const SizedBox(width: 8),
                          Text('${service.totalBookings} bookings',
                              style: AppTextStyles.bodySmall),
                          if (service.isEcoFriendly) ...[
                            const SizedBox(width: 8),
                            const StatusChip(
                              label: 'Eco',
                              color: AppColors.primary,
                              emoji: '🌿',
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.outline,
              labelStyle: AppTextStyles.label,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Packages'),
                Tab(text: 'Reviews'),
                Tab(text: 'FAQs'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Overview tab
            _OverviewTab(service: service),
            // Packages tab
            _PackagesTab(service: service),
            // Reviews tab
            _ReviewsTab(service: service),
            // FAQs tab
            _FaqsTab(service: service),
          ],
        ),
      ),

      // Sticky bottom bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: Color(0x1A3C4A3C))),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Starting from', style: AppTextStyles.caption),
                Text(
                  AppUtils.formatCurrency(service.basePrice),
                  style: AppTextStyles.price,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/book/${widget.serviceId}'),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3FE56C), Color(0xFF1A8C3F)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text('Book Now',
                      style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab content widgets ───────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('About this service', style: AppTextStyles.h4),
        const SizedBox(height: 8),
        Text(service.description, style: AppTextStyles.body),
        const SizedBox(height: 20),
        Text("What's included", style: AppTextStyles.h4),
        const SizedBox(height: 8),
        ...[
          'Professional equipment provided',
          'Eco-friendly cleaning products',
          'Background-verified workers',
          'Service guarantee',
        ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Text(item, style: AppTextStyles.body),
                ],
              ),
            )),
        const SizedBox(height: 20),
        if (service.isEcoFriendly) ...[
          Text('Eco Impact', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: AppDecorations.primaryCard(),
            child: Row(
              children: [
                const Text('🌿', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Earn ${service.ecoPointsEarned} eco points',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary)),
                      Text('Uses eco-friendly products',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PackagesTab extends StatelessWidget {
  const _PackagesTab({required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: service.packages.length,
      itemBuilder: (context, i) {
        final pkg = service.packages[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pkg.name, style: AppTextStyles.h4),
                    const SizedBox(height: 4),
                    Text(pkg.description, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Text('${pkg.duration} min',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppUtils.formatCurrency(pkg.price.toDouble()),
                      style: AppTextStyles.price),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => context.push('/book/${service.id}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Book',
                          style: AppTextStyles.label.copyWith(
                              color: AppColors.onPrimary)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Rating breakdown
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Row(
            children: [
              Column(
                children: [
                  Text(service.avgRating.toStringAsFixed(1),
                      style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary)),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < service.avgRating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: const Color(0xFFFFC107),
                        size: 14,
                      ),
                    ),
                  ),
                  Text('${service.totalBookings} reviews',
                      style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final fraction = star == 5
                        ? 0.7
                        : star == 4
                            ? 0.2
                            : 0.05;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$star', style: AppTextStyles.caption),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: fraction,
                                backgroundColor: AppColors.surfaceContainer,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFFC107)),
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Sample reviews
        ..._sampleReviews.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: AppDecorations.card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(r['avatar']!,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['name']!, style: AppTextStyles.bodyMedium),
                            Text(r['date']!, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(
                          int.parse(r['rating']!),
                          (_) => const Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(r['review']!, style: AppTextStyles.body),
                ],
              ),
            )),
      ],
    );
  }

  static const _sampleReviews = [
    {
      'avatar': '👩',
      'name': 'Priya M.',
      'date': '2 days ago',
      'rating': '5',
      'review': 'Excellent service! The worker was very professional and thorough.',
    },
    {
      'avatar': '👨',
      'name': 'Rahul K.',
      'date': '1 week ago',
      'rating': '4',
      'review': 'Good service overall. Arrived on time and did a great job.',
    },
  ];
}

class _FaqsTab extends StatelessWidget {
  const _FaqsTab({required this.service});
  // ignore: unused_field
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _faqs.length,
      itemBuilder: (context, i) {
        final faq = _faqs[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: AppDecorations.card(),
          child: ExpansionTile(
            title: Text(faq['q']!, style: AppTextStyles.bodyMedium),
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.outline,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(faq['a']!, style: AppTextStyles.body),
              ),
            ],
          ),
        );
      },
    );
  }

  static const _faqs = [
    {
      'q': 'How long does the service take?',
      'a': 'Duration depends on the package selected. Basic packages take 60-90 minutes, while premium packages may take 2-3 hours.',
    },
    {
      'q': 'Are the products eco-friendly?',
      'a': 'Yes! We use only certified eco-friendly, biodegradable cleaning products that are safe for your family and the environment.',
    },
    {
      'q': 'Can I reschedule my booking?',
      'a': 'Yes, you can reschedule up to 2 hours before the scheduled time without any charges.',
    },
    {
      'q': 'What if I\'m not satisfied?',
      'a': 'We offer a 100% satisfaction guarantee. If you\'re not happy, we\'ll redo the service for free.',
    },
  ];
}
