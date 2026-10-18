import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _analytics = true;
  bool _personalization = true;
  bool _preciseLocation = true;
  bool _backgroundLocation = false;
  bool _twoFactor = false;

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Delete Account?', style: TextStyle(color: AppColors.error)),
        content: const Text(
          'This action is irreversible. All your data will be permanently deleted.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.onError),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested'), backgroundColor: AppColors.error),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active Sessions', style: TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            const _SessionTile(device: 'iPhone 14 Pro', location: 'Bangalore, IN', current: true),
            const _SessionTile(device: 'Chrome on Windows', location: 'Bangalore, IN', current: false),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out of all sessions'), backgroundColor: AppColors.error),
                  );
                },
                child: const Text('Sign out all'),
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
        title: const Text('Privacy & Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader('Data Sharing'),
          _ToggleTile(title: 'Analytics', subtitle: 'Help improve the app', value: _analytics, onChanged: (v) => setState(() => _analytics = v)),
          _ToggleTile(title: 'Personalization', subtitle: 'Personalized recommendations', value: _personalization, onChanged: (v) => setState(() => _personalization = v)),
          const SizedBox(height: 16),
          const _SectionHeader('Location'),
          _ToggleTile(title: 'Precise Location', subtitle: 'For accurate service matching', value: _preciseLocation, onChanged: (v) => setState(() => _preciseLocation = v)),
          _ToggleTile(title: 'Background Location', subtitle: 'Track worker in background', value: _backgroundLocation, onChanged: (v) => setState(() => _backgroundLocation = v)),
          const SizedBox(height: 16),
          const _SectionHeader('Account'),
          _ActionTile(title: 'Change Phone Number', icon: Icons.phone_outlined, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone change coming soon')))),
          _ActionTile(title: 'Delete Account', icon: Icons.delete_outline, color: AppColors.error, onTap: _showDeleteDialog),
          const SizedBox(height: 16),
          const _SectionHeader('Security'),
          _ToggleTile(title: 'Two-Factor Auth', subtitle: 'Extra security for your account', value: _twoFactor, onChanged: (v) => setState(() => _twoFactor = v)),
          _ActionTile(title: 'Active Sessions', icon: Icons.devices_outlined, onTap: _showActiveSessions),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.title, required this.subtitle, required this.value, required this.onChanged});
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: AppColors.onSurface, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        inactiveThumbColor: AppColors.outline,
        inactiveTrackColor: AppColors.surfaceContainerLow,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.title, required this.icon, required this.onTap, this.color});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.onSurface;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: c, size: 22),
        title: Text(title, style: TextStyle(color: c, fontSize: 15)),
        trailing: color == null ? const Icon(Icons.chevron_right, color: AppColors.outline, size: 20) : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.device, required this.location, required this.current});
  final String device;
  final String location;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.devices, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(location, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          if (current)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
              child: const Text('Current', style: TextStyle(color: AppColors.primary, fontSize: 11)),
            ),
        ],
      ),
    );
  }
}
