import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'INR';

  final List<_Language> _languages = const [
    _Language(name: 'English', native: 'English'),
    _Language(name: 'Hindi', native: 'हिंदी'),
    _Language(name: 'Tamil', native: 'தமிழ்'),
    _Language(name: 'Telugu', native: 'తెలుగు'),
    _Language(name: 'Kannada', native: 'ಕನ್ನಡ'),
    _Language(name: 'Bengali', native: 'বাংলা'),
  ];

  final List<_Currency> _currencies = const [
    _Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    _Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Language & Region'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Language',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: _languages.map((lang) {
                      final selected = _selectedLanguage == lang.name;
                      return RadioListTile<String>(
                        value: lang.name,
                        groupValue: _selectedLanguage,
                        onChanged: (v) => setState(() => _selectedLanguage = v!),
                        activeColor: AppColors.primary,
                        title: Row(
                          children: [
                            Text(lang.name, style: const TextStyle(color: AppColors.onSurface, fontSize: 15)),
                            const SizedBox(width: 8),
                            Text(lang.native, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
                          ],
                        ),
                        selected: selected,
                        selectedTileColor: AppColors.primary.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Currency',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: _currencies.map((c) {
                      return RadioListTile<String>(
                        value: c.code,
                        groupValue: _selectedCurrency,
                        onChanged: (v) => setState(() => _selectedCurrency = v!),
                        activeColor: AppColors.primary,
                        title: Text('${c.code} ${c.symbol} — ${c.name}',
                            style: const TextStyle(color: AppColors.onSurface, fontSize: 15)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language updated!'), backgroundColor: AppColors.primary),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Language {
  const _Language({required this.name, required this.native});
  final String name;
  final String native;
}

class _Currency {
  const _Currency({required this.code, required this.symbol, required this.name});
  final String code;
  final String symbol;
  final String name;
}
