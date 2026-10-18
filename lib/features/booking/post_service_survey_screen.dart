import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class PostServiceSurveyScreen extends ConsumerStatefulWidget {
  const PostServiceSurveyScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  ConsumerState<PostServiceSurveyScreen> createState() =>
      _PostServiceSurveyScreenState();
}

class _PostServiceSurveyScreenState
    extends ConsumerState<PostServiceSurveyScreen> {
  int _punctuality = 0;
  int _quality = 0;
  int _ecoFriendliness = 0;
  String _recommend = '';
  final Set<String> _liked = {};
  final _suggestionsController = TextEditingController();

  @override
  void dispose() {
    _suggestionsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_punctuality == 0 || _quality == 0 || _ecoFriendliness == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please rate all categories')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Thanks! 🌿',
            style: TextStyle(color: AppColors.primary)),
        content: const Text(
            'You earned 25 bonus points for completing the survey!',
            style: TextStyle(color: AppColors.onSurface)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/orders');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Awesome!'),
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
        title: const Text('Post-Service Survey'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),

            _StarRatingRow(
              label: 'Worker Punctuality',
              value: _punctuality,
              onChanged: (v) => setState(() => _punctuality = v),
            ),
            const SizedBox(height: 16),
            _StarRatingRow(
              label: 'Service Quality',
              value: _quality,
              onChanged: (v) => setState(() => _quality = v),
            ),
            const SizedBox(height: 16),
            _StarRatingRow(
              label: 'Eco-Friendliness',
              value: _ecoFriendliness,
              onChanged: (v) => setState(() => _ecoFriendliness = v),
            ),
            const SizedBox(height: 24),

            const Text('Would you recommend Ecomins?',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(
              children: ['Yes', 'No', 'Maybe'].map((opt) {
                final selected = _recommend == opt;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _recommend = opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : const Color(0x333C4A3C),
                        ),
                      ),
                      child: Text(opt,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            const Text('What did you like most?',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Punctual',
                'Thorough',
                'Eco-friendly',
                'Friendly',
                'Affordable',
              ].map((tag) {
                final selected = _liked.contains(tag);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _liked.remove(tag);
                      } else {
                        _liked.add(tag);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : const Color(0x333C4A3C),
                      ),
                    ),
                    child: Text(tag,
                        style: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _suggestionsController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Any suggestions?',
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
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text('🌿', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text('Complete survey to earn 25 bonus points!',
                      style: TextStyle(
                          color: AppColors.primary, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Submit Survey',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StarRatingRow extends StatelessWidget {
  const _StarRatingRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(5, (i) {
            final star = i + 1;
            return GestureDetector(
              onTap: () => onChanged(star),
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  star <= value ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
