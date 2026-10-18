import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _currentPlan = 'Free';

  final List<_Plan> _plans = const [
    _Plan(
      name: 'Basic',
      price: 99,
      features: ['2 services/month', 'Standard support', '1x eco points'],
      recommended: false,
    ),
    _Plan(
      name: 'Pro',
      price: 299,
      features: ['10 services/month', 'Priority support', '2x eco points'],
      recommended: true,
    ),
    _Plan(
      name: 'Premium',
      price: 599,
      features: ['Unlimited services', 'Dedicated support', '3x eco points', 'Carbon credits'],
      recommended: false,
    ),
  ];

  void _upgrade(String planName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: Text('Upgrade to $planName?', style: const TextStyle(color: AppColors.onSurface)),
        content: Text(
          'You will be subscribed to the $planName plan.',
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _currentPlan = planName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Subscribed to $planName!'), backgroundColor: AppColors.primary),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
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
        title: const Text('Subscription Plans'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current plan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Current Plan', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_currentPlan,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Free Plan', style: TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('• 1 service/month\n• Basic support\n• 1x eco points',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Upgrade Your Plan',
              style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._plans.map((p) => _PlanCard(
            plan: p,
            isCurrent: _currentPlan == p.name,
            onUpgrade: () => _upgrade(p.name),
          )),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.isCurrent, required this.onUpgrade});
  final _Plan plan;
  final bool isCurrent;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: plan.recommended ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: plan.recommended ? AppColors.primary : AppColors.outline,
          width: plan.recommended ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(plan.name,
                  style: const TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              if (plan.recommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Recommended',
                      style: TextStyle(color: AppColors.onPrimary, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Current Plan',
                      style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
                ),
              const Spacer(),
              Text('₹${plan.price}/mo',
                  style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          ...plan.features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text(f, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: isCurrent
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.outline,
                      side: const BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: null,
                    child: const Text('Current Plan'),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: onUpgrade,
                    child: const Text('Upgrade', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Plan {
  const _Plan({required this.name, required this.price, required this.features, required this.recommended});
  final String name;
  final int price;
  final List<String> features;
  final bool recommended;
}
