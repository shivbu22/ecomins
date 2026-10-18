import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class ServiceReminderScreen extends StatefulWidget {
  const ServiceReminderScreen({super.key});

  @override
  State<ServiceReminderScreen> createState() => _ServiceReminderScreenState();
}

class _ServiceReminderScreenState extends State<ServiceReminderScreen> {
  final List<_Reminder> _reminders = [
    const _Reminder(emoji: '🧹', name: 'Home Cleaning', schedule: 'Every Monday 9 AM', isOn: true),
    const _Reminder(emoji: '🗑️', name: 'Garbage Pickup', schedule: 'Daily 8 AM', isOn: true),
    const _Reminder(emoji: '🌱', name: 'Garden Care', schedule: 'Every 2 weeks', isOn: false),
  ];

  String _notifSound = 'Default';
  String _advanceNotice = '30 min';

  void _showAddReminder() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Reminder',
                style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...[
              ('🧹', 'Home Cleaning'),
              ('🗑️', 'Garbage Pickup'),
              ('🌱', 'Garden Care'),
              ('♻️', 'Recycling Pickup'),
            ].map(
              (item) => ListTile(
                leading: Text(item.$1,
                    style: const TextStyle(fontSize: 22)),
                title: Text(item.$2,
                    style: const TextStyle(color: AppColors.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _reminders.add(_Reminder(
                      emoji: item.$1,
                      name: item.$2,
                      schedule: 'Every week',
                      isOn: true,
                    ));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${item.$2} reminder added!')),
                  );
                },
              ),
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
        title: const Text('Service Reminders 🔔'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Never forget your scheduled services',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 16),

          ..._reminders.asMap().entries.map(
            (entry) {
              final i = entry.key;
              final r = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(r.emoji,
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.name,
                              style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text(r.schedule,
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.onSurfaceVariant, size: 18),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error, size: 18),
                      onPressed: () {
                        setState(() => _reminders.removeAt(i));
                      },
                    ),
                    Switch(
                      value: r.isOn,
                      onChanged: (v) {
                        setState(() => _reminders[i] =
                            _Reminder(
                                emoji: r.emoji,
                                name: r.name,
                                schedule: r.schedule,
                                isOn: v));
                      },
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showAddReminder,
              icon: const Icon(Icons.add),
              label: const Text('Add Reminder'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Settings
          const Text('Reminder Settings',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          _SettingTile(
            label: 'Notification Sound',
            value: _notifSound,
            options: const ['Default', 'Chime', 'Bell', 'Silent'],
            onChanged: (v) => setState(() => _notifSound = v),
          ),
          const SizedBox(height: 8),
          _SettingTile(
            label: 'Advance Notice',
            value: _advanceNotice,
            options: const ['15 min', '30 min', '1 hr'],
            onChanged: (v) => setState(() => _advanceNotice = v),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Reminder {
  final String emoji, name, schedule;
  final bool isOn;
  const _Reminder(
      {required this.emoji,
      required this.name,
      required this.schedule,
      required this.isOn});
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label, value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.onSurface, fontSize: 14)),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: AppColors.surfaceContainerLow,
            style: const TextStyle(
                color: AppColors.primary, fontSize: 13),
            underline: const SizedBox(),
            items: options
                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
