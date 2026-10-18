import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  late List<Map<String, dynamic>> _methods;

  @override
  void initState() {
    super.initState();
    _methods = MockData.paymentMethods
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'card':
        return Icons.credit_card_outlined;
      case 'upi':
        return Icons.account_balance_outlined;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.payment_outlined;
    }
  }

  String _subtitleFor(Map<String, dynamic> m) {
    switch (m['type'] as String) {
      case 'card':
        return '•••• ${m['last4']}';
      case 'upi':
        return m['handle'] as String;
      case 'wallet':
        return '₹${(m['balance'] as double).toStringAsFixed(0)} balance';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Payment Methods'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._methods.map((m) {
            final isDefault = m['isDefault'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: isDefault
                    ? Border.all(color: AppColors.primary, width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _iconFor(m['type'] as String),
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              m['name'] as String,
                              style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Default',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          _subtitleFor(m),
                          style: const TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.error, size: 20),
                    onPressed: () {
                      setState(() => _methods.remove(m));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '${m['name']} removed')),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add payment method coming soon')),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Payment Method'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
