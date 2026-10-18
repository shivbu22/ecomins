import 'package:flutter/material.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

class HelpTicketScreen extends StatefulWidget {
  const HelpTicketScreen({super.key});

  @override
  State<HelpTicketScreen> createState() => _HelpTicketScreenState();
}

class _HelpTicketScreenState extends State<HelpTicketScreen> {
  String _issueType = 'Booking Issue';
  String _priority = 'Medium';
  final _descCtrl = TextEditingController();

  final _issueTypes = [
    'Booking Issue',
    'Payment Problem',
    'Worker Complaint',
    'App Bug',
    'Other',
  ];
  final _priorities = ['Low', 'Medium', 'High'];

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Raise a Ticket'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Issue Type',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _issueTypes.map((t) {
              final sel = _issueType == t;
              return ChoiceChip(
                label: Text(t),
                selected: sel,
                onSelected: (_) => setState(() => _issueType = t),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundColor: AppColors.surfaceContainer,
                labelStyle: TextStyle(
                  color: sel ? AppColors.primary : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: sel ? AppColors.primary : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Priority',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: _priorities.map((p) {
              final sel = _priority == p;
              final color = p == 'High'
                  ? AppColors.error
                  : p == 'Medium'
                      ? Colors.amber
                      : AppColors.primary;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _priority = p),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: sel
                          ? color.withValues(alpha: 0.2)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: sel ? color : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      p,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: sel ? color : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descCtrl,
            maxLines: 5,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Describe your issue in detail...',
              hintStyle:
                  const TextStyle(color: AppColors.onSurfaceVariant),
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Screenshot attached!')),
            ),
            icon: const Icon(Icons.attach_file),
            label: const Text('Attach Screenshot'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            label: 'Submit Ticket',
            icon: Icons.send_outlined,
            onTap: () => _showTicketDialog(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: const Text('Ticket Raised! ✅',
            style: TextStyle(color: AppColors.onSurface)),
        content: const Text(
          'Ticket #ECO-2024-1234 raised.\nWe\'ll respond within 24 hours.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
