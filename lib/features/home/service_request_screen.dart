import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _descController = TextEditingController();
  final _suggestionsController = TextEditingController();
  String _selectedCategory = 'Cleaning';
  String _urgency = 'Normal';
  DateTime _preferredDate = DateTime.now().add(const Duration(days: 1));
  String _preferredTime = '10:00 AM';
  double _budgetMin = 100;
  double _budgetMax = 2000;

  @override
  void dispose() {
    _descController.dispose();
    _suggestionsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please describe the service you need')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        title: const Text('Request Submitted! 🎉',
            style: TextStyle(color: AppColors.primary)),
        content: const Text(
            "Request submitted! We'll find a worker within 2 hours.",
            style: TextStyle(color: AppColors.onSurface)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Done'),
          ),
        ],
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
        title: const Text('Request a Service'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Can't find what you need? Tell us!",
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _descController,
            maxLines: 4,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Describe the service you need...',
              hintStyle: const TextStyle(color: AppColors.outline),
              filled: true,
              fillColor: AppColors.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text('Category',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Cleaning',
              'Garbage',
              'Recycling',
              'Garden',
              'Security',
              'Other',
            ].map((cat) {
              final selected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : const Color(0x333C4A3C),
                    ),
                  ),
                  child: Text(cat,
                      style: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          const Text('Urgency',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: ['Normal', 'Urgent', 'Emergency'].map((u) {
              final selected = _urgency == u;
              final color = u == 'Emergency'
                  ? AppColors.error
                  : u == 'Urgent'
                      ? const Color(0xFFFFC107)
                      : AppColors.primary;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _urgency = u),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? color.withValues(alpha: 0.15)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? color
                            : const Color(0x333C4A3C),
                      ),
                    ),
                    child: Text(u,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: selected ? color : AppColors.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Date + time
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _preferredDate,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 30)),
                      builder: (_, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                              primary: AppColors.primary),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() => _preferredDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${_preferredDate.day}/${_preferredDate.month}',
                          style: const TextStyle(
                              color: AppColors.onSurface, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: _preferredTime,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceContainerLow,
                    style: const TextStyle(
                        color: AppColors.onSurface, fontSize: 13),
                    underline: const SizedBox(),
                    items: ['8:00 AM', '10:00 AM', '12:00 PM', '2:00 PM', '4:00 PM']
                        .map((t) => DropdownMenuItem(
                            value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _preferredTime = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Budget slider
          const Text('Budget Range',
              style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            '₹${_budgetMin.toStringAsFixed(0)} — ₹${_budgetMax.toStringAsFixed(0)}',
            style: const TextStyle(
                color: AppColors.primary, fontSize: 13),
          ),
          RangeSlider(
            values: RangeValues(_budgetMin, _budgetMax),
            min: 100,
            max: 5000,
            divisions: 49,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surfaceContainerLow,
            onChanged: (v) {
              setState(() {
                _budgetMin = v.start;
                _budgetMax = v.end;
              });
            },
          ),
          const SizedBox(height: 16),

          // Photos placeholder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0x333C4A3C),
                  style: BorderStyle.solid),
            ),
            child: const Column(
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    color: AppColors.onSurfaceVariant, size: 32),
                SizedBox(height: 6),
                Text('Add photos to help us understand',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Submit Request',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
