import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

const _opportunities = [
  (
    '🧹',
    'Community Clean-Up Coordinator',
    'Organize neighbourhood clean-up drives',
    '2 hrs/week',
    150,
  ),
  (
    '📚',
    'Eco Education Ambassador',
    'Spread eco awareness in schools and communities',
    '3 hrs/week',
    200,
  ),
  (
    '♻️',
    'Recycling Drive Organizer',
    'Set up and manage local recycling collection points',
    '2 hrs/week',
    180,
  ),
];

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  final List<String> _applied = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Volunteer with Us 🌍'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🌍', style: TextStyle(fontSize: 36)),
                SizedBox(height: 8),
                Text(
                  'Make a bigger impact',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Join our volunteer network and earn bonus eco points while helping your community.',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Opportunities',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ..._opportunities.map((o) => _OpportunityCard(
                emoji: o.$1,
                title: o.$2,
                description: o.$3,
                commitment: o.$4,
                points: o.$5,
                applied: _applied.contains(o.$2),
                onApply: () => _showApplicationSheet(context, o.$2),
              )),
          const SizedBox(height: 20),
          const Text(
            'My Applications',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (_applied.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Text('📋', style: TextStyle(fontSize: 36)),
                    SizedBox(height: 8),
                    Text(
                      'No applications yet',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._applied.map((a) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pending_outlined,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(a,
                            style: const TextStyle(
                                color: AppColors.onSurface, fontSize: 13)),
                      ),
                      const Text('Pending',
                          style: TextStyle(
                              color: Colors.amber, fontSize: 12)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  void _showApplicationSheet(BuildContext context, String role) {
    final nameCtrl = TextEditingController();
    final motivationCtrl = TextEditingController();
    String availability = 'Weekends';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apply: $role',
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _SheetField(controller: nameCtrl, label: 'Your Name'),
              const SizedBox(height: 12),
              const Text('Availability',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Weekdays', 'Weekends', 'Both'].map((a) {
                  final sel = availability == a;
                  return ChoiceChip(
                    label: Text(a),
                    selected: sel,
                    onSelected: (_) => setS(() => availability = a),
                    selectedColor:
                        AppColors.primary.withValues(alpha: 0.2),
                    backgroundColor: AppColors.surfaceContainerLow,
                    labelStyle: TextStyle(
                      color: sel
                          ? AppColors.primary
                          : AppColors.onSurface,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: sel
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              _SheetField(
                  controller: motivationCtrl,
                  label: 'Why do you want to volunteer?',
                  maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _applied.add(role));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Application submitted!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.commitment,
    required this.points,
    required this.applied,
    required this.onApply,
  });

  final String emoji;
  final String title;
  final String description;
  final String commitment;
  final int points;
  final bool applied;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(description,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule,
                  color: AppColors.outline, size: 14),
              const SizedBox(width: 4),
              Text(commitment,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12)),
              const SizedBox(width: 12),
              const Icon(Icons.eco, color: AppColors.primary, size: 14),
              const SizedBox(width: 4),
              Text('+$points pts/week',
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 12)),
              const Spacer(),
              ElevatedButton(
                onPressed: applied ? null : onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: applied
                      ? AppColors.surfaceContainerLow
                      : AppColors.primary,
                  foregroundColor: applied
                      ? AppColors.onSurfaceVariant
                      : AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(applied ? 'Applied' : 'Apply',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField(
      {required this.controller, required this.label, this.maxLines = 1});
  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
