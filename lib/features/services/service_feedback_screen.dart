import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class ServiceFeedbackScreen extends StatefulWidget {
  const ServiceFeedbackScreen({super.key});

  @override
  State<ServiceFeedbackScreen> createState() => _ServiceFeedbackScreenState();
}

class _ServiceFeedbackScreenState extends State<ServiceFeedbackScreen> {
  String _category = 'App Experience';
  int _selectedEmoji = -1;
  final TextEditingController _controller = TextEditingController();

  final List<String> _categories = [
    'App Experience',
    'Service Quality',
    'Worker Behavior',
    'Pricing',
    'Other',
  ];

  final List<_EmojiRating> _emojis = const [
    _EmojiRating(emoji: '😡', label: 'Terrible'),
    _EmojiRating(emoji: '😕', label: 'Bad'),
    _EmojiRating(emoji: '😐', label: 'Okay'),
    _EmojiRating(emoji: '😊', label: 'Good'),
    _EmojiRating(emoji: '😍', label: 'Amazing'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedEmoji == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Thank You! 🙏', style: TextStyle(color: AppColors.onSurface)),
        content: const Text(
          'Your feedback helps us improve Ecomins for everyone. We appreciate your time!',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/home');
            },
            child: const Text('Back to Home'),
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
        title: const Text('Share Feedback'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Help us improve Ecomins',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Text('Category', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((c) {
              final selected = _category == c;
              return GestureDetector(
                onTap: () => setState(() => _category = c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.outline),
                  ),
                  child: Text(
                    c,
                    style: TextStyle(
                      color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('How was your experience?', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _emojis.asMap().entries.map((e) {
              final selected = _selectedEmoji == e.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedEmoji = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        e.value.emoji,
                        style: TextStyle(fontSize: selected ? 36 : 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.value.label,
                        style: TextStyle(
                          color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Tell us more...', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: 5,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Share your thoughts, suggestions, or issues...',
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
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              side: const BorderSide(color: AppColors.outline),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photo attached!'), backgroundColor: AppColors.primary),
            ),
            icon: const Icon(Icons.attach_file_outlined),
            label: const Text('Attach Photo'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submit,
              child: const Text('Submit Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiRating {
  const _EmojiRating({required this.emoji, required this.label});
  final String emoji;
  final String label;
}
