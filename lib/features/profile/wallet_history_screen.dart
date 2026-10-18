import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/auth_providers.dart';

class WalletHistoryScreen extends ConsumerStatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  ConsumerState<WalletHistoryScreen> createState() =>
      _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends ConsumerState<WalletHistoryScreen> {
  String _filter = 'All';

  static const _filters = ['All', 'Credits', 'Debits'];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'Credits') {
      return MockData.transactions
          .where((t) => t['type'] == 'credit')
          .toList();
    } else if (_filter == 'Debits') {
      return MockData.transactions
          .where((t) => t['type'] == 'debit')
          .toList();
    }
    return MockData.transactions;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final balance = user.wallet.balance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Wallet'),
      ),
      body: Column(
        children: [
          // Balance card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add money coming soon')),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Money'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Withdraw coming soon')),
                        ),
                        icon: const Icon(Icons.arrow_upward, size: 16),
                        label: const Text('Withdraw'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final f = _filters[index];
                final selected = _filter == f;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Transaction list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 48, color: AppColors.outline),
                        SizedBox(height: 12),
                        Text(
                          'No transactions',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tx = _filtered[index];
                      final isCredit = tx['type'] == 'credit';
                      final amount = tx['amount'] as double;
                      return GestureDetector(
                        onTap: () =>
                            context.push('/profile/wallet/${tx['id']}'),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isCredit
                                      ? AppColors.primary
                                          .withValues(alpha: 0.15)
                                      : AppColors.error
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    isCredit
                                        ? Icons.eco_outlined
                                        : Icons.payment_outlined,
                                    color: isCredit
                                        ? AppColors.primary
                                        : AppColors.error,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx['description'] as String,
                                      style: const TextStyle(
                                        color: AppColors.onSurface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      tx['date'] as String,
                                      style: const TextStyle(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isCredit ? '+' : '-'}₹${amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: isCredit
                                      ? AppColors.primary
                                      : AppColors.error,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
