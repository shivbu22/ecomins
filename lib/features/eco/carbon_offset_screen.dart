import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class CarbonOffsetScreen extends StatefulWidget {
  const CarbonOffsetScreen({super.key});

  @override
  State<CarbonOffsetScreen> createState() => _CarbonOffsetScreenState();
}

class _CarbonOffsetScreenState extends State<CarbonOffsetScreen> {
  int _selectedOption = 2; // default: 2 tonnes
  double _customAmount = 1.0;

  final List<_OffsetOption> _options = const [
    _OffsetOption(tonnes: 0.5, price: 750, projects: 1),
    _OffsetOption(tonnes: 1.0, price: 1500, projects: 2),
    _OffsetOption(tonnes: 2.0, price: 2800, projects: 3, recommended: true),
  ];

  void _showPaymentDialog() {
    final option = _selectedOption < _options.length ? _options[_selectedOption] : null;
    final price = option != null ? option.price : (_customAmount * 1500).toInt();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Confirm Payment', style: TextStyle(color: AppColors.onSurface)),
        content: Text(
          'Pay ₹$price to offset your carbon footprint.\n\nThis supports verified climate projects.',
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.onPrimary),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Carbon offset purchased!'), backgroundColor: AppColors.primary),
              );
            },
            child: const Text('Pay Now'),
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
        title: const Text('Offset Your Carbon'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Footprint card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A2A1A), Color(0xFF0D1A0D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Carbon Footprint', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                SizedBox(height: 8),
                Text('~2.4 tonnes CO₂/year', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('Average Indian: 1.9 tonnes/year', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Choose Offset Amount', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._options.asMap().entries.map((e) => _OptionCard(
            option: e.value,
            selected: _selectedOption == e.key,
            onTap: () => setState(() => _selectedOption = e.key),
          )),
          // Custom amount
          GestureDetector(
            onTap: () => setState(() => _selectedOption = _options.length),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOption == _options.length ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _selectedOption == _options.length ? AppColors.primary : AppColors.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        value: _options.length,
                        groupValue: _selectedOption,
                        onChanged: (v) => setState(() => _selectedOption = v!),
                        activeColor: AppColors.primary,
                      ),
                      const Text('Custom Amount', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (_selectedOption == _options.length) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.surfaceContainerLow,
                              thumbColor: AppColors.primary,
                            ),
                            child: Slider(
                              value: _customAmount,
                              min: 0.5,
                              max: 10,
                              divisions: 19,
                              onChanged: (v) => setState(() => _customAmount = v),
                            ),
                          ),
                        ),
                        Text('${_customAmount.toStringAsFixed(1)}t', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Text('≈ ₹${(_customAmount * 1500).toInt()}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Selected Projects', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          const _ProjectCard(name: 'Western Ghats Reforestation', emoji: '🌳', standard: 'VCS'),
          const _ProjectCard(name: 'Solar Village Initiative', emoji: '☀️', standard: 'Gold Standard'),
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
              onPressed: _showPaymentDialog,
              child: const Text('Offset Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.option, required this.selected, required this.onTap});
  final _OffsetOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : AppColors.outline, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Radio<bool>(value: true, groupValue: selected, onChanged: (_) => onTap(), activeColor: AppColors.primary),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${option.tonnes} tonne${option.tonnes > 1 ? 's' : ''}',
                          style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700)),
                      if (option.recommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                          child: const Text('Recommended', style: TextStyle(color: AppColors.onPrimary, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  Text('${option.projects} project${option.projects > 1 ? 's' : ''}',
                      style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            Text('₹${option.price}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.name, required this.emoji, required this.standard});
  final String name;
  final String emoji;
  final String standard;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(color: AppColors.onSurface, fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
            child: Text(standard, style: const TextStyle(color: AppColors.primary, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

class _OffsetOption {
  const _OffsetOption({required this.tonnes, required this.price, required this.projects, this.recommended = false});
  final double tonnes;
  final int price;
  final int projects;
  final bool recommended;
}
