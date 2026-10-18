import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/personalization_providers.dart';

class TipWorkerScreen extends ConsumerStatefulWidget {
  const TipWorkerScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<TipWorkerScreen> createState() => _TipWorkerScreenState();
}

class _TipWorkerScreenState extends ConsumerState<TipWorkerScreen> {
  double? _selectedTip;
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  double get _effectiveTip {
    if (_customController.text.isNotEmpty) {
      return double.tryParse(_customController.text) ?? 0;
    }
    return _selectedTip ?? 0;
  }

  void _sendTip() {
    final amount = _effectiveTip;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a tip amount')),
      );
      return;
    }
    ref.read(tipAmountProvider.notifier).state = amount;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('₹${amount.toStringAsFixed(0)} tip sent to Ravi Kumar! 🙏'),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Tip Your Worker'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Skip',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Show your appreciation 💚',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Worker card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                        child: Text('👨',
                            style: TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ravi Kumar',
                            style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('Excellent service! ⭐⭐⭐⭐⭐',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Select tip amount',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            Row(
              children: [20.0, 50.0, 100.0, 200.0].map((amount) {
                final selected = _selectedTip == amount &&
                    _customController.text.isEmpty;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTip = amount;
                        _customController.clear();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : const Color(0x333C4A3C),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        '₹${amount.toStringAsFixed(0)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
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
              onChanged: (_) => setState(() => _selectedTip = null),
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
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTip = null;
                  _customController.clear();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x333C4A3C)),
                ),
                child: const Text('No tip',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 13)),
              ),
            ),

            const Spacer(),

            if (_effectiveTip > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Center(
                  child: Text(
                    '₹${_effectiveTip.toStringAsFixed(0)} will be added to your bill',
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 13),
                  ),
                ),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendTip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _effectiveTip > 0
                      ? 'Send ₹${_effectiveTip.toStringAsFixed(0)} Tip'
                      : 'Send Tip',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
