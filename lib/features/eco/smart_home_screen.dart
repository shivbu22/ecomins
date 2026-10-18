import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class SmartHomeScreen extends StatelessWidget {
  const SmartHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Smart Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect your smart home',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Integrate with your smart home devices to automate eco-friendly routines.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _ConnectTile(
              icon: Icons.home_outlined,
              label: 'Google Home',
              subtitle: 'Connect Google Home devices',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Home integration coming soon')),
              ),
            ),
            const SizedBox(height: 12),
            _ConnectTile(
              icon: Icons.speaker_outlined,
              label: 'Amazon Alexa',
              subtitle: 'Connect Alexa-enabled devices',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alexa integration coming soon')),
              ),
            ),
            const SizedBox(height: 12),
            _ConnectTile(
              icon: Icons.phone_android_outlined,
              label: 'Apple HomeKit',
              subtitle: 'Connect HomeKit accessories',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('HomeKit integration coming soon')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectTile extends StatelessWidget {
  const _ConnectTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(label,
            style: const TextStyle(
                color: AppColors.onSurface, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 12)),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Connect', style: TextStyle(fontSize: 12)),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
