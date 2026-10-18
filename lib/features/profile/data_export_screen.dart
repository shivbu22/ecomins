import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';

class DataExportScreen extends StatelessWidget {
  const DataExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('My Data'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'You own your data',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Download or export your personal data at any time.',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ..._dataItems.map((d) => _DataTile(
                emoji: d.$1,
                title: d.$2,
                format: d.$3,
                onDownload: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Downloading ${d.$2}...')),
                ),
              )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.outline.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.privacy_tip_outlined,
                    color: AppColors.outline, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your data is protected under GDPR and India\'s DPDP Act. We never sell your data.',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showDeleteDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.15),
              foregroundColor: AppColors.error,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Request Account Deletion',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: const Text('Delete Account?',
            style: TextStyle(color: AppColors.onSurface)),
        content: const Text(
          'This action is irreversible. All your data, bookings, and eco points will be permanently deleted.',
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
                    content: Text(
                        'Deletion request submitted. We\'ll process it within 30 days.')),
              );
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

const _dataItems = [
  ('📋', 'Booking History', 'CSV'),
  ('🌿', 'Eco Impact Report', 'PDF'),
  ('💳', 'Transaction History', 'CSV'),
  ('👤', 'Profile Data', 'JSON'),
];

class _DataTile extends StatelessWidget {
  const _DataTile({
    required this.emoji,
    required this.title,
    required this.format,
    required this.onDownload,
  });

  final String emoji;
  final String title;
  final String format;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                Text(format,
                    style: const TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined,
                color: AppColors.primary),
            onPressed: onDownload,
          ),
        ],
      ),
    );
  }
}
