import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/auth_providers.dart';

class WalletTopupScreen extends ConsumerStatefulWidget {
  const WalletTopupScreen({super.key});

  @override
  ConsumerState<WalletTopupScreen> createState() => _WalletTopupScreenState();
}

class _WalletTopupScreenState extends ConsumerState<WalletTopupScreen> {
  double? _selectedAmount;
  final _customController = TextEditingController();
  String _paymentMethod = 'upi';
  final _upiController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _customController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  double get _effectiveAmount {
    if (_customController.text.isNotEmpty) {
      return double.tryParse(_customController.text) ?? 0;
    }
    return _selectedAmount ?? 0;
  }

  Future<void> _proceed() async {
    final amount = _effectiveAmount;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an amount')),
      );
      return;
    }
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Update wallet balance
    // In a real app we'd update the wallet; here we show success dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('✅ Success!',
            style: TextStyle(color: AppColors.primary)),
        content: Text(
            '₹${amount.toStringAsFixed(0)} added to wallet!',
            style: const TextStyle(color: AppColors.onSurface)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Add Money to Wallet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current balance
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Balance',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12)),
                      Text(
                        '₹${user.wallet.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Quick Amounts',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [100.0, 200.0, 500.0, 1000.0, 2000.0].map((a) {
                final selected = _selectedAmount == a &&
                    _customController.text.isEmpty;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = a;
                      _customController.clear();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : const Color(0x333C4A3C),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '₹${a.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: selected
                            ? AppColors.primary
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.onSurface),
              onChanged: (_) => setState(() => _selectedAmount = null),
              decoration: InputDecoration(
                hintText: 'Custom amount',
                hintStyle: const TextStyle(color: AppColors.outline),
                prefixText: '₹ ',
                prefixStyle: const TextStyle(color: AppColors.onSurface),
                filled: true,
                fillColor: AppColors.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Payment Method',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...[
              ('upi', '📱 UPI'),
              ('card', '💳 Card'),
              ('netbanking', '🏦 Net Banking'),
            ].map(
              (item) => GestureDetector(
                onTap: () =>
                    setState(() => _paymentMethod = item.$1),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _paymentMethod == item.$1
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _paymentMethod == item.$1
                          ? AppColors.primary
                          : const Color(0x333C4A3C),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(item.$2,
                          style: const TextStyle(
                              color: AppColors.onSurface, fontSize: 14)),
                      const Spacer(),
                      if (_paymentMethod == item.$1)
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 18),
                    ],
                  ),
                ),
              ),
            ),

            if (_paymentMethod == 'upi') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _upiController,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Enter UPI ID (e.g. name@upi)',
                  hintStyle: const TextStyle(color: AppColors.outline),
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),

            const Center(
              child: Text('No transaction fees',
                  style: TextStyle(
                      color: AppColors.primary, fontSize: 12)),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary),
                      )
                    : Text(
                        _effectiveAmount > 0
                            ? 'Proceed to Pay ₹${_effectiveAmount.toStringAsFixed(0)}'
                            : 'Proceed to Pay',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
