import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EcoCalculatorScreen extends StatefulWidget {
  const EcoCalculatorScreen({super.key});

  @override
  State<EcoCalculatorScreen> createState() => _EcoCalculatorScreenState();
}

class _EcoCalculatorScreenState extends State<EcoCalculatorScreen> {
  double _plastic = 0;
  double _paper = 0;
  double _ewaste = 0;
  double _cleaning = 0;

  double get _co2Saved =>
      _plastic * 2.5 + _paper * 1.2 + _ewaste * 5.0 + _cleaning * 0.8;

  int get _ecoPoints =>
      (_plastic * 10 + _paper * 8 + _ewaste * 20 + _cleaning * 5).toInt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Eco Impact Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Impact shared!'), backgroundColor: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Result card
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CO₂ Saved', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                      Text(
                        '${_co2Saved.toStringAsFixed(1)} kg',
                        style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Eco Points', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                      Text(
                        '$_ecoPoints pts',
                        style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SliderTile(
            emoji: '🧴',
            label: 'Plastic recycled',
            unit: 'kg',
            value: _plastic,
            max: 50,
            onChanged: (v) => setState(() => _plastic = v),
          ),
          _SliderTile(
            emoji: '📦',
            label: 'Paper recycled',
            unit: 'kg',
            value: _paper,
            max: 30,
            onChanged: (v) => setState(() => _paper = v),
          ),
          _SliderTile(
            emoji: '💻',
            label: 'E-waste recycled',
            unit: 'items',
            value: _ewaste,
            max: 10,
            onChanged: (v) => setState(() => _ewaste = v),
          ),
          _SliderTile(
            emoji: '🧹',
            label: 'Cleaning services booked',
            unit: 'times',
            value: _cleaning,
            max: 20,
            onChanged: (v) => setState(() => _cleaning = v),
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
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impact recorded!'), backgroundColor: AppColors.primary),
              ),
              child: const Text('Add to My Impact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.emoji,
    required this.label,
    required this.unit,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final String emoji;
  final String label;
  final String unit;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
              ),
              Text(
                '${value.toInt()} $unit',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceContainerLow,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: max,
              divisions: max.toInt(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
