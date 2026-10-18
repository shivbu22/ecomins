import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class AccountSecurityScreen extends ConsumerWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Account Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 10,
                      backgroundColor:
                          AppColors.surfaceContainerLow,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '75%',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Good',
                        style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Security Checklist',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _SecurityItem(
            icon: Icons.phone_android,
            title: 'Phone verified',
            status: true,
            actionLabel: null,
            onAction: null,
          ),
          const _SecurityItem(
            icon: Icons.person_outline,
            title: 'Profile complete',
            status: true,
            actionLabel: null,
            onAction: null,
          ),
          _SecurityItem(
            icon: Icons.security,
            title: 'Two-factor auth',
            status: false,
            actionLabel: 'Enable',
            onAction: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('2FA setup coming soon!')),
            ),
          ),
          _SecurityItem(
            icon: Icons.email_outlined,
            title: 'Recovery email',
            status: false,
            actionLabel: 'Add',
            onAction: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add recovery email')),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Login Activity',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _SessionTile(
            device: 'Android — Samsung Galaxy S23',
            time: 'Today, 10:32 AM',
            isCurrent: true,
          ),
          const _SessionTile(
            device: 'Chrome — Windows 11',
            time: 'Yesterday, 8:15 PM',
            isCurrent: false,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.surfaceContainer,
                  title: const Text('Sign out all devices?',
                      style: TextStyle(color: AppColors.onSurface)),
                  content: const Text(
                    'You will be signed out from all devices except this one.',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Signed out all devices')),
                        );
                      },
                      child: const Text('Sign Out',
                          style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.15),
              foregroundColor: AppColors.error,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Sign Out All Devices',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SecurityItem extends StatelessWidget {
  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final bool status;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: AppColors.onSurface, fontSize: 14)),
          ),
          if (status)
            const Icon(Icons.check_circle,
                color: AppColors.primary, size: 20)
          else ...[
            const Icon(Icons.warning_amber_rounded,
                color: Colors.amber, size: 20),
            if (actionLabel != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.device,
    required this.time,
    required this.isCurrent,
  });

  final String device;
  final String time;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.devices, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device,
                    style: const TextStyle(
                        color: AppColors.onSurface, fontSize: 13)),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 11)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Current',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}
