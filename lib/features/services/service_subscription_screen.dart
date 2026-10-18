import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

const _plans = [
  ('🧹', 'Weekly Cleaning', '₹999/mo', 'Save 30%', 999),
  ('🗑️', 'Daily Garbage', '₹399/mo', 'Save 20%', 399),
  ('🧴', 'Monthly Deep Clean', '₹1,499/mo', 'Save 25%', 1499),
  ('🌱', 'Garden Care', '₹799/mo', 'Save 15%', 799),
];

class ServiceSubscriptionScreen extends StatefulWidget {
  const ServiceSubscriptionScreen({super.key});

  @override
  State<ServiceSubscriptionScreen> createState() =>
      _ServiceSubscriptionScreenState();
}

class _ServiceSubscriptionScreenState
    extends State<ServiceSubscriptionScreen> {
  final Set<int> _selected = {};

  int get _total =>
      _selected.fold(0, (sum, i) => sum + _plans[i].$5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Subscribe & Save'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Never run out of clean!',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_plans.length, (i) {
                  final plan = _plans[i];
                  final sel = _selected.contains(i);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (sel) {
                        _selected.remove(i);
                      } else {
                        _selected.add(i);
                      }
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(plan.$1,
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(plan.$2,
                                    style: const TextStyle(
                                      color: AppColors.onSurface,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    )),
                                Row(
                                  children: [
                                    Text(plan.$3,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.2),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(plan.$4,
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: sel,
                            onChanged: (v) => setState(() {
                              if (v) {
                                _selected.add(i);
                              } else {
                                _selected.remove(i);
                              }
                            }),
                            activeThumbColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (_selected.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total / month',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14)),
                      Text(
                        '₹$_total',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    label: 'Subscribe Now',
                    icon: Icons.subscriptions_outlined,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Subscription activated!')),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
