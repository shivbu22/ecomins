import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EcoNewsScreen extends StatefulWidget {
  const EcoNewsScreen({super.key});

  @override
  State<EcoNewsScreen> createState() => _EcoNewsScreenState();
}

class _EcoNewsScreenState extends State<EcoNewsScreen> {
  String _filter = 'All';
  final List<String> _filters = ['All', 'Tips', 'News', 'Guides'];

  final List<_Article> _articles = const [
    _Article(emoji: '🌿', title: '5 Ways to Reduce Plastic at Home', summary: 'Simple swaps that can dramatically cut your plastic usage and help the environment.', readTime: '5 min read', date: '24 Oct', category: 'Tips', content: 'Plastic pollution is one of the biggest environmental challenges. Here are 5 practical ways to reduce plastic at home:\n\n1. Use reusable bags\n2. Switch to bar soap\n3. Buy in bulk\n4. Use a reusable water bottle\n5. Choose products with minimal packaging\n\nThese small changes can make a big difference over time!'),
    _Article(emoji: '♻️', title: 'How Recycling Saves the Planet', summary: 'The science behind recycling and why it matters more than ever in 2024.', readTime: '7 min read', date: '22 Oct', category: 'News', content: 'Recycling is one of the most effective ways to reduce waste and conserve resources. When we recycle, we reduce the need for raw materials, save energy, and reduce greenhouse gas emissions.\n\nIn India alone, recycling could save millions of tonnes of CO₂ annually. Every item you recycle makes a difference!'),
    _Article(emoji: '🌱', title: 'Start Composting Today', summary: 'A beginner\'s guide to turning kitchen waste into garden gold.', readTime: '6 min read', date: '20 Oct', category: 'Guides', content: 'Composting is nature\'s way of recycling. By composting your kitchen and garden waste, you can create rich fertilizer for your plants while reducing landfill waste.\n\nGetting started is easy:\n1. Choose a compost bin\n2. Add green and brown materials\n3. Keep it moist\n4. Turn regularly\n5. Use in 2-3 months'),
    _Article(emoji: '☀️', title: 'Solar Energy for Beginners', summary: 'Everything you need to know about switching to solar power at home.', readTime: '8 min read', date: '18 Oct', category: 'Guides', content: 'Solar energy is becoming increasingly affordable and accessible. Here\'s what you need to know:\n\n- Solar panels convert sunlight to electricity\n- Average payback period: 5-7 years\n- Government subsidies available in India\n- Reduces electricity bills by 70-90%\n- Low maintenance required'),
    _Article(emoji: '🚰', title: 'Water Conservation Tips', summary: 'Easy habits that can save thousands of litres of water every month.', readTime: '4 min read', date: '15 Oct', category: 'Tips', content: 'Water is precious. Here are simple ways to conserve it:\n\n1. Fix leaky taps immediately\n2. Take shorter showers\n3. Use a bucket instead of a hose\n4. Collect rainwater\n5. Water plants in the evening\n\nA family of 4 can save up to 50,000 litres per year with these tips!'),
    _Article(emoji: '🌍', title: 'Understanding Carbon Credits', summary: 'What are carbon credits and how can you use them to offset your footprint?', readTime: '9 min read', date: '12 Oct', category: 'News', content: 'Carbon credits are a market-based mechanism to reduce greenhouse gas emissions. One carbon credit = one tonne of CO₂ reduced or removed.\n\nHow it works:\n- Companies buy credits to offset emissions\n- Credits fund green projects\n- You can buy personal carbon credits\n- Verified by international standards (VCS, Gold Standard)\n\nEcomins makes it easy to offset your personal carbon footprint!'),
  ];

  List<_Article> get _filtered {
    if (_filter == 'All') return _articles;
    return _articles.where((a) => a.category == _filter).toList();
  }

  void _showArticle(BuildContext context, _Article article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Text(article.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(article.title,
                      style: const TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(article.readTime, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                const SizedBox(width: 8),
                Text('• ${article.date}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.outline),
            const SizedBox(height: 16),
            Text(article.content, style: const TextStyle(color: AppColors.onSurface, fontSize: 15, height: 1.7)),
          ],
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
        title: const Text('Eco News & Tips'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
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
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _ArticleCard(
                article: _filtered[i],
                onTap: () => _showArticle(context, _filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});
  final _Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(article.summary,
                      style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(article.category, style: const TextStyle(color: AppColors.primary, fontSize: 10)),
                      ),
                      const SizedBox(width: 8),
                      Text(article.readTime, style: const TextStyle(color: AppColors.outline, fontSize: 11)),
                      const SizedBox(width: 8),
                      Text(article.date, style: const TextStyle(color: AppColors.outline, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Article {
  const _Article({required this.emoji, required this.title, required this.summary, required this.readTime, required this.date, required this.category, required this.content});
  final String emoji;
  final String title;
  final String summary;
  final String readTime;
  final String date;
  final String category;
  final String content;
}
