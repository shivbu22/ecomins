import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class AppTourScreen extends StatefulWidget {
  const AppTourScreen({super.key});

  @override
  State<AppTourScreen> createState() => _AppTourScreenState();
}

class _AppTourScreenState extends State<AppTourScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_TourPage> _pages = const [
    _TourPage(
      emoji: '🏠',
      title: 'Home Screen Features',
      desc: 'Browse 8+ eco-friendly services, check live worker availability, and access flash deals — all from your home screen.',
      highlight: 'Quick access to everything you need',
    ),
    _TourPage(
      emoji: '📅',
      title: 'How to Book a Service',
      desc: 'Choose a service, pick your time slot, and confirm. Our verified workers arrive in as little as 10 minutes!',
      highlight: 'Booking takes less than 60 seconds',
    ),
    _TourPage(
      emoji: '🌱',
      title: 'Eco Points System',
      desc: 'Every service you book earns eco points. Recycling earns the most! Accumulate points to unlock rewards and badges.',
      highlight: 'Earn up to 100 points per service',
    ),
    _TourPage(
      emoji: '📍',
      title: 'Live Tracking',
      desc: 'Track your worker in real-time on the map. Get notified when they\'re nearby and when the service is complete.',
      highlight: 'Real-time GPS tracking',
    ),
    _TourPage(
      emoji: '🎁',
      title: 'Rewards Marketplace',
      desc: 'Redeem your eco points for vouchers, products, plant trees, or offset your carbon footprint. New rewards added weekly!',
      highlight: 'Over 20 rewards available',
    ),
    _TourPage(
      emoji: '🏆',
      title: 'Community Leaderboard',
      desc: 'Compete with eco-conscious users in your city. Climb the leaderboard to earn exclusive badges and bonus points!',
      highlight: 'Join 10,000+ eco warriors',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Welcome to Ecomins! 👋'),
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Skip Tour', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (context, i) => _TourPageWidget(page: _pages[i], pageNum: i + 1, total: _pages.length),
            ),
          ),
          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i ? AppColors.primary : AppColors.outline,
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _next,
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Start Exploring' : 'Next',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TourPageWidget extends StatelessWidget {
  const _TourPageWidget({required this.page, required this.pageNum, required this.total});
  final _TourPage page;
  final int pageNum;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.15), AppColors.primary.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(child: Text(page.emoji, style: const TextStyle(fontSize: 56))),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$pageNum of $total', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
          const SizedBox(height: 16),
          Text(
            page.title,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 22, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.desc,
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text(page.highlight, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TourPage {
  const _TourPage({required this.emoji, required this.title, required this.desc, required this.highlight});
  final String emoji;
  final String title;
  final String desc;
  final String highlight;
}
