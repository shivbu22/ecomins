import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/mock/mock_data.dart';

class ServiceAvailabilityCheckerScreen extends StatefulWidget {
  const ServiceAvailabilityCheckerScreen({super.key});

  @override
  State<ServiceAvailabilityCheckerScreen> createState() =>
      _ServiceAvailabilityCheckerScreenState();
}

class _ServiceAvailabilityCheckerScreenState
    extends State<ServiceAvailabilityCheckerScreen> {
  final _addressController = TextEditingController(
      text: '42, 5th Cross, Koramangala, Bangalore');
  String _selectedService = 'cleaning_basic';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';
  bool _isChecking = false;
  bool? _isAvailable;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _isChecking = true;
      _isAvailable = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isChecking = false;
      _isAvailable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Check Availability'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _addressController,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: InputDecoration(
              labelText: 'Address',
              labelStyle:
                  const TextStyle(color: AppColors.onSurfaceVariant),
              prefixIcon: const Icon(Icons.location_on_outlined,
                  color: AppColors.primary),
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
          const SizedBox(height: 14),

          // Service selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _selectedService,
              isExpanded: true,
              dropdownColor: AppColors.surfaceContainerLow,
              style: const TextStyle(
                  color: AppColors.onSurface, fontSize: 14),
              underline: const SizedBox(),
              items: [
                ('cleaning_basic', '🧹 Home Cleaning'),
                ('garbage_daily', '🗑️ Garbage Pickup'),
                ('recycling_paper', '♻️ Paper Recycling'),
                ('garden_maintenance', '🌱 Garden Care'),
              ]
                  .map((item) => DropdownMenuItem(
                        value: item.$1,
                        child: Text(item.$2),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedService = v);
              },
            ),
          ),
          const SizedBox(height: 14),

          // Date + time
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
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
                      setState(() => _selectedDate = picked);
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
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
                    value: _selectedTime,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceContainerLow,
                    style: const TextStyle(
                        color: AppColors.onSurface, fontSize: 13),
                    underline: const SizedBox(),
                    items: [
                      '8:00 AM',
                      '10:00 AM',
                      '12:00 PM',
                      '2:00 PM',
                      '4:00 PM',
                      '6:00 PM',
                    ]
                        .map((t) => DropdownMenuItem(
                            value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedTime = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isChecking ? null : _check,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isChecking
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary),
                        ),
                        SizedBox(width: 10),
                        Text('Checking...'),
                      ],
                    )
                  : const Text('Check Now',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 20),

          if (_isAvailable == true) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Text('✅', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Text('3 workers available at this time!',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...MockData.workers.take(3).map(
              (w) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(w.avatarEmoji,
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.name,
                              style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Color(0xFFFFC107), size: 12),
                              Text(' ${w.rating}',
                                  style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Booking with ${w.name}...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Book',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (_isAvailable == false) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Text('❌', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        'No workers available. Try a different time.',
                        style: TextStyle(
                            color: AppColors.error, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
