import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/personalization_models.dart';
import 'package:ecomins/providers/personalization_providers.dart';

class HomeProfileScreen extends ConsumerStatefulWidget {
  const HomeProfileScreen({super.key});

  @override
  ConsumerState<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends ConsumerState<HomeProfileScreen> {
  late String _homeType;
  late int _residents;
  late bool _hasPets;
  late bool _hasGarden;
  late List<String> _timeSlots;

  @override
  void initState() {
    super.initState();
    final p = ref.read(homeProfileProvider);
    _homeType = p.homeType;
    _residents = p.residents;
    _hasPets = p.hasPets;
    _hasGarden = p.hasGarden;
    _timeSlots = List.from(p.preferredTimeSlots);
  }

  void _save() {
    ref.read(homeProfileProvider.notifier).state = HomeProfile(
      homeType: _homeType,
      residents: _residents,
      hasPets: _hasPets,
      hasGarden: _hasGarden,
      preferredTimeSlots: _timeSlots,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "Profile saved! We'll personalize your experience."),
        backgroundColor: AppColors.primary,
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
        title: const Text('My Home Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tell us about your home',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'We use this to personalize your service recommendations.',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 24),

          const _SectionLabel('Home Type'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['1BHK', '2BHK', '3BHK', 'Villa', 'Office'].map((t) {
              final selected = _homeType == t;
              return GestureDetector(
                onTap: () => setState(() => _homeType = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
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
                    t,
                    style: TextStyle(
                      color: selected
                          ? AppColors.primary
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          const _SectionLabel('Number of Residents'),
          const SizedBox(height: 10),
          Row(
            children: [
              _StepperBtn(
                icon: Icons.remove,
                onTap: () {
                  if (_residents > 1) setState(() => _residents--);
                },
              ),
              const SizedBox(width: 16),
              Text(
                '$_residents',
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              _StepperBtn(
                icon: Icons.add,
                onTap: () {
                  if (_residents < 10) setState(() => _residents++);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          const _SectionLabel('Pets & Garden'),
          const SizedBox(height: 10),
          _ToggleTile(
            emoji: '🐾',
            title: 'Do you have pets?',
            subtitle: 'Affects cleaning product recommendations',
            value: _hasPets,
            onChanged: (v) => setState(() => _hasPets = v),
          ),
          const SizedBox(height: 8),
          _ToggleTile(
            emoji: '🌱',
            title: 'Do you have a garden?',
            subtitle: 'Enables garden care recommendations',
            value: _hasGarden,
            onChanged: (v) => setState(() => _hasGarden = v),
          ),
          const SizedBox(height: 24),

          const _SectionLabel('Preferred Time Slots'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ('morning', '🌅 Morning'),
              ('afternoon', '☀️ Afternoon'),
              ('evening', '🌙 Evening'),
            ].map((slot) {
              final selected = _timeSlots.contains(slot.$1);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      if (_timeSlots.length > 1) _timeSlots.remove(slot.$1);
                    } else {
                      _timeSlots.add(slot.$1);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
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
                    slot.$2,
                    style: TextStyle(
                      color: selected
                          ? AppColors.primary
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Live preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended for you',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (_hasPets)
                  const Text('🐾 Pet-Safe Cleaning',
                      style: TextStyle(
                          color: AppColors.onSurface, fontSize: 13)),
                if (_hasGarden)
                  const Text('🌱 Garden Care',
                      style: TextStyle(
                          color: AppColors.onSurface, fontSize: 13)),
                Text('🧹 Home Cleaning for $_homeType',
                    style: const TextStyle(
                        color: AppColors.onSurface, fontSize: 13)),
                Text(
                    '👥 Services for $_residents resident${_residents > 1 ? 's' : ''}',
                    style: const TextStyle(
                        color: AppColors.onSurface, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Save Profile',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  const _StepperBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String emoji, title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
