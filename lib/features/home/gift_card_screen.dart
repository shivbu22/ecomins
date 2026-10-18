import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  int _amount = 500;
  String _occasion = 'Birthday';
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _customCtrl = TextEditingController();

  final _amounts = [500, 1000, 2000, 5000];
  final _occasions = ['Birthday', 'Anniversary', 'Housewarming', 'Thank You', 'Other'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _msgCtrl.dispose();
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Gift Cards 🎁'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Give the gift of clean living',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          // Gift card preview
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF0D2E1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🌿', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    const Text(
                      'Ecomins Gift Card',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹$_amount',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  _msgCtrl.text.isEmpty
                      ? 'Your personal message here...'
                      : _msgCtrl.text,
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Occasion: $_occasion',
                  style: const TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Amount',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._amounts.map((a) {
                final sel = _amount == a;
                return GestureDetector(
                  onTap: () => setState(() => _amount = a),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '₹$a',
                      style: TextStyle(
                        color: sel
                            ? AppColors.onPrimary
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _customCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: AppColors.onSurface, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Custom',
                    hintStyle: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final parsed = int.tryParse(v);
                    if (parsed != null) setState(() => _amount = parsed);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Occasion',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _occasions.map((o) {
              final sel = _occasion == o;
              return ChoiceChip(
                label: Text(o),
                selected: sel,
                onSelected: (_) => setState(() => _occasion = o),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundColor: AppColors.surfaceContainer,
                labelStyle: TextStyle(
                  color: sel ? AppColors.primary : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: sel ? AppColors.primary : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _Field(controller: _nameCtrl, label: 'Recipient Name', hint: 'Enter name'),
          const SizedBox(height: 12),
          _Field(
              controller: _contactCtrl,
              label: 'Phone / Email',
              hint: 'Enter phone or email'),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Personal Message',
                  style: TextStyle(
                      color: AppColors.onSurfaceVariant, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _msgCtrl,
                maxLines: 3,
                style: const TextStyle(color: AppColors.onSurface),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Write a heartfelt message...',
                  hintStyle: const TextStyle(
                      color: AppColors.onSurfaceVariant),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Send Gift Card',
            icon: Icons.card_giftcard,
            onTap: () => _showSuccess(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: const Text('🎉 Gift Card Sent!',
            style: TextStyle(color: AppColors.onSurface)),
        content: Text(
          'Your ₹$_amount gift card has been sent successfully!',
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
}

class _Field extends StatelessWidget {
  const _Field(
      {required this.controller, required this.label, required this.hint});
  final TextEditingController controller;
  final String label;
  final String hint;

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
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.onSurfaceVariant),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
