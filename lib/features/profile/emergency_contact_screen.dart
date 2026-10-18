import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  bool _shareLocation = false;

  final List<_Contact> _contacts = [
    _Contact(name: 'Priya Sharma', phone: '+91 98765 43210', relation: 'Sister'),
    _Contact(name: 'Rajesh Kumar', phone: '+91 87654 32109', relation: 'Friend'),
  ];

  final List<_SafetyTip> _tips = const [
    _SafetyTip(title: 'Verify worker identity', content: 'Always check the worker\'s ID and photo before letting them in. Our app shows their verified profile.'),
    _SafetyTip(title: 'Share your booking', content: 'Share your booking details with a trusted contact before the service begins.'),
    _SafetyTip(title: 'Rate your experience', content: 'Always rate your service after completion. This helps keep our community safe.'),
  ];

  void _showSOS() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Row(
          children: [
            Icon(Icons.emergency, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Text('Emergency SOS', style: TextStyle(color: AppColors.error)),
          ],
        ),
        content: const Text(
          'Contacting Ecomins support team...\n\nYour location is being shared with our safety team.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.onError),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddContact() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Emergency Contact', style: TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                filled: true,
                fillColor: AppColors.surfaceContainer,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                filled: true,
                fillColor: AppColors.surfaceContainer,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                    setState(() => _contacts.add(_Contact(
                      name: nameController.text,
                      phone: phoneController.text,
                      relation: 'Contact',
                    )));
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact added!'), backgroundColor: AppColors.primary),
                  );
                },
                child: const Text('Add Contact', style: TextStyle(fontWeight: FontWeight.w700)),
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
        title: const Text('Emergency & Safety'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SOS Button
          Center(
            child: GestureDetector(
              onTap: _showSOS,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.error, width: 3),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency, color: AppColors.error, size: 40),
                    SizedBox(height: 4),
                    Text('SOS', style: TextStyle(color: AppColors.error, fontSize: 20, fontWeight: FontWeight.w900)),
                    Text('Press in emergency', style: TextStyle(color: AppColors.error, fontSize: 10), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Share location toggle
          Container(
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text('Share My Location', style: TextStyle(color: AppColors.onSurface)),
              subtitle: const Text('Share location with emergency contacts during service', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              value: _shareLocation,
              onChanged: (v) => setState(() => _shareLocation = v),
              activeThumbColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Emergency Contacts', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
              const Spacer(),
              TextButton.icon(
                onPressed: _showAddContact,
                icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
                label: const Text('Add', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._contacts.map((c) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 20,
                  child: Icon(Icons.person, color: AppColors.onPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                      Text('${c.phone} • ${c.relation}', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call_outlined, color: AppColors.primary),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${c.name}...'), backgroundColor: AppColors.primary),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 24),
          const Text('Safety Tips', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ..._tips.map((t) => _SafetyTipTile(tip: t)),
        ],
      ),
    );
  }
}

class _SafetyTipTile extends StatefulWidget {
  const _SafetyTipTile({required this.tip});
  final _SafetyTip tip;

  @override
  State<_SafetyTipTile> createState() => _SafetyTipTileState();
}

class _SafetyTipTileState extends State<_SafetyTipTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
            title: Text(widget.tip.title, style: const TextStyle(color: AppColors.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
            trailing: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.outline),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(widget.tip.content, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.5)),
            ),
        ],
      ),
    );
  }
}

class _Contact {
  _Contact({required this.name, required this.phone, required this.relation});
  final String name;
  final String phone;
  final String relation;
}

class _SafetyTip {
  const _SafetyTip({required this.title, required this.content});
  final String title;
  final String content;
}
