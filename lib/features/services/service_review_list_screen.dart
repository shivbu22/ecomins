import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class ServiceReviewListScreen extends StatefulWidget {
  const ServiceReviewListScreen({super.key, required this.serviceId});
  final String serviceId;

  @override
  State<ServiceReviewListScreen> createState() => _ServiceReviewListScreenState();
}

class _ServiceReviewListScreenState extends State<ServiceReviewListScreen> {
  String _filter = 'All';
  final List<String> _filters = ['All', '5★', '4★', '3★'];

  final List<_Review> _reviews = const [
    _Review(name: 'Meera N.', emoji: '👩', date: '24 Oct', stars: 5, comment: 'Absolutely fantastic! The worker was punctual and thorough.'),
    _Review(name: 'Vikram S.', emoji: '👨', date: '22 Oct', stars: 5, comment: 'Best cleaning service I have used. Highly recommend!'),
    _Review(name: 'Ananya P.', emoji: '👩', date: '20 Oct', stars: 4, comment: 'Very good service. Minor areas were missed but overall great.'),
    _Review(name: 'Rahul G.', emoji: '👨', date: '18 Oct', stars: 5, comment: 'Eco-friendly products used. Love the green approach!'),
    _Review(name: 'Sneha R.', emoji: '👩', date: '15 Oct', stars: 4, comment: 'Quick and efficient. Will book again.'),
    _Review(name: 'Karthik I.', emoji: '👨', date: '12 Oct', stars: 3, comment: 'Decent service but took longer than expected.'),
    _Review(name: 'Divya M.', emoji: '👩', date: '10 Oct', stars: 5, comment: 'Superb! The team was professional and friendly.'),
    _Review(name: 'Arun K.', emoji: '👨', date: '8 Oct', stars: 4, comment: 'Good value for money. Satisfied with the results.'),
  ];

  List<_Review> get _filteredReviews {
    if (_filter == 'All') return _reviews;
    final stars = int.parse(_filter[0]);
    return _reviews.where((r) => r.stars == stars).toList();
  }

  void _showWriteReview() {
    int selectedStars = 5;
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Write a Review', style: TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setModalState(() => selectedStars = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      i < selectedStars ? Icons.star : Icons.star_border,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 3,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  hintStyle: const TextStyle(color: AppColors.outline),
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review submitted!'), backgroundColor: AppColors.primary),
                    );
                  },
                  child: const Text('Submit Review', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Reviews'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        onPressed: _showWriteReview,
        icon: const Icon(Icons.edit),
        label: const Text('Write a Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Rating summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Column(
                  children: [
                    Text('4.8', style: TextStyle(color: AppColors.primary, fontSize: 48, fontWeight: FontWeight.w900)),
                    Row(children: [
                      Icon(Icons.star, color: AppColors.primary, size: 16),
                      Icon(Icons.star, color: AppColors.primary, size: 16),
                      Icon(Icons.star, color: AppColors.primary, size: 16),
                      Icon(Icons.star, color: AppColors.primary, size: 16),
                      Icon(Icons.star_half, color: AppColors.primary, size: 16),
                    ]),
                    SizedBox(height: 4),
                    Text('128 reviews', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _RatingBar(stars: 5, percent: 0.70),
                      _RatingBar(stars: 4, percent: 0.20),
                      _RatingBar(stars: 3, percent: 0.07),
                      _RatingBar(stars: 2, percent: 0.02),
                      _RatingBar(stars: 1, percent: 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                    backgroundColor: AppColors.surfaceContainer,
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    labelStyle: TextStyle(color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
                    side: BorderSide(color: selected ? AppColors.primary : AppColors.outline),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          ..._filteredReviews.map((r) => _ReviewCard(review: r)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({required this.stars, required this.percent});
  final int stars;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars★', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: AppColors.surfaceContainerLow,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('${(percent * 100).toInt()}%', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final _Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                    Text(review.date, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < review.stars ? Icons.star : Icons.star_border,
                  color: AppColors.primary,
                  size: 14,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
        ],
      ),
    );
  }
}

class _Review {
  const _Review({required this.name, required this.emoji, required this.date, required this.stars, required this.comment});
  final String name;
  final String emoji;
  final String date;
  final int stars;
  final String comment;
}
