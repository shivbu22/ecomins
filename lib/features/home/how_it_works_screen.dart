import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_Step> _steps = const [
    _Step(emoji: '📍', title: 'Choose your service', desc: 'Browse from 8+ eco-friendly home services. From cleaning to recycling, we have it all.'),
    _Step(emoji: '📅', title: 'Pick a time', desc: 'Schedule at your convenience — today, tomorrow, or any day. Morning, afternoon, or evening slots available.'),
    _Step(emoji: '👷', title: 'Worker arrives in 10 min', desc: 'Our verified, eco-certified workers arrive promptly. Track them live on the map.'),
    _Step(emoji: '✅', title: 'Service done, earn eco points', desc: 'Every service earns you eco points. The greener the service, the more points you earn!'),
    _Step(emoji: '🎁', title: 'Redeem rewards', desc: 'Use your eco points to redeem vouchers, products, plant trees, or offset your carbon footprint.'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _steps.length - 1) {
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
        title: const Text('How Ecomins Works'),
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Skip', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _steps.length,
              itemBuilder: (context, i) => _StepPage(step: _steps[i], index: i),
            ),
          ),
          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (i) => AnimatedContainer(
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
                  _currentPage == _steps.length - 1 ? 'Get Started' : 'Next',
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

class _StepPage extends StatelessWidget {
  const _StepPage({required this.step, required this.index});
  final _Step step;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(child: Text(step.emoji, style: const TextStyle(fontSize: 52))),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Step ${index + 1}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 24, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.desc,
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Step {
  const _Step({required this.emoji, required this.title, required this.desc});
  final String emoji;
  final String title;
  final String desc;
}
