import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  final Map<String, bool> _prefs = {
    'Booking Updates': true,
    'Eco Milestones': true,
    'New Badges': true,
    'Promotional Offers': false,
    'Weekly Eco Report': true,
    'Worker Nearby Alerts': true,
    'Payment Confirmations': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Notification Preferences'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: _prefs.entries.map((entry) {
                      return SwitchListTile(
                        title: Text(entry.key, style: const TextStyle(color: AppColors.onSurface, fontSize: 15)),
                        value: entry.value,
                        onChanged: (v) => setState(() => _prefs[entry.key] = v),
                        activeThumbColor: AppColors.primary,
                        inactiveThumbColor: AppColors.outline,
                        inactiveTrackColor: AppColors.surfaceContainerLow,
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
                  const SnackBar(content: Text('Preferences saved!'), backgroundColor: AppColors.primary),
                ),
                child: const Text('Save Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
