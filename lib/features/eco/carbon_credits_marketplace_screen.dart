import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/eco_model.dart';
import 'package:ecomins/providers/eco_providers.dart';

class CarbonCreditsMarketplaceScreen extends ConsumerWidget {
  const CarbonCreditsMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(carbonCreditsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Carbon Credits'),
      ),
      body: credits.isEmpty
          ? const Center(
              child: Text('No projects available',
                  style: TextStyle(color: AppColors.outline)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: credits.length,
              itemBuilder: (context, index) =>
                  _CreditCard(credit: credits[index]),
            ),
    );
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({required this.credit});

  final CarbonCredit credit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(
                child: Text(
                  credit.projectName,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_outlined,
                        color: Colors.green, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      credit.verificationStandard,
                      style: const TextStyle(color: Colors.green, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            credit.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.cloud_outlined,
                label: '${credit.co2TonnesOffset} t CO₂',
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.currency_rupee,
                label: '₹${credit.priceInr.toStringAsFixed(0)}/credit',
                color: AppColors.primary,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Carbon credit purchase coming soon')),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Buy Credits', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
