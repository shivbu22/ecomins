import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

const _checklistItems = [
  'Clear the area to be cleaned',
  'Ensure water supply is available',
  'Keep pets secured',
  'Have payment ready',
  'Provide access to all rooms',
];

class ServiceChecklistScreen extends StatefulWidget {
  const ServiceChecklistScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<ServiceChecklistScreen> createState() =>
      _ServiceChecklistScreenState();
}

class _ServiceChecklistScreenState extends State<ServiceChecklistScreen> {
  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    final ready = _checked.length;
    final total = _checklistItems.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Service Checklist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text('📋', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'What to prepare before your worker arrives',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Checklist',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: ready == total
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$ready/$total items ready',
                    style: TextStyle(
                      color: ready == total
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _checklistItems.length,
                itemBuilder: (context, i) {
                  final checked = _checked.contains(i);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (checked) {
                        _checked.remove(i);
                      } else {
                        _checked.add(i);
                      }
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: checked
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: checked
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            checked
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: checked
                                ? AppColors.primary
                                : AppColors.outline,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _checklistItems[i],
                              style: TextStyle(
                                color: checked
                                    ? AppColors.onSurface
                                    : AppColors.onSurfaceVariant,
                                fontSize: 14,
                                decoration: checked
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: "I'm Ready",
              icon: Icons.check_circle_outline,
              onTap: () => context.push('/book/${widget.serviceId}'),
            ),
          ],
        ),
      ),
    );
  }
}
