import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/booking_providers.dart';

class RateServiceScreen extends ConsumerStatefulWidget {
  const RateServiceScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<RateServiceScreen> createState() => _RateServiceScreenState();
}

class _RateServiceScreenState extends ConsumerState<RateServiceScreen> {
  int _selectedRating = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final service = ref.read(bookingRepositoryProvider);
      await service.submitRating(
        widget.bookingId,
        _selectedRating.toDouble(),
        _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
      );
      if (mounted) {
        // Show tip prompt
        _showTipPrompt();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit rating: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showTipPrompt() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add a tip? 💚',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('Show appreciation for great service',
                style: TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [20, 50, 100, 200].map((amount) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(
                            '/booking/${widget.bookingId}/tip');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.15),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('₹$amount',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/booking/${widget.bookingId}/tip');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tip ₹50'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/orders');
                    },
                    child: const Text('Skip',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant)),
                  ),
                ),
              ],
            ),
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
        title: const Text('Rate Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your feedback helps us improve our services.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = star),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        star <= _selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 44,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _selectedRating == 0
                    ? 'Tap to rate'
                    : ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'][_selectedRating],
                style: TextStyle(
                  color: _selectedRating == 0 ? AppColors.outline : AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: const TextStyle(color: AppColors.outline),
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
