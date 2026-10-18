import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

class AddressAddScreen extends ConsumerStatefulWidget {
  const AddressAddScreen({super.key});

  @override
  ConsumerState<AddressAddScreen> createState() => _AddressAddScreenState();
}

class _AddressAddScreenState extends ConsumerState<AddressAddScreen> {
  String _label = 'Home';
  final _addressCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  @override
  void dispose() {
    _addressCtrl.dispose();
    _landmarkCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  void _useCurrentLocation() {
    setState(() {
      _addressCtrl.text = '42, 5th Cross, Koramangala';
      _cityCtrl.text = 'Bangalore';
      _pincodeCtrl.text = '560034';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location filled: Koramangala, Bangalore')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Add New Address'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Label',
            style: TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Home', 'Work', 'Other'].map((l) {
              final selected = _label == l;
              return ChoiceChip(
                label: Text(l),
                selected: selected,
                onSelected: (_) => setState(() => _label = l),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundColor: AppColors.surfaceContainer,
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _useCurrentLocation,
            icon: const Icon(Icons.my_location, size: 18),
            label: const Text('Use Current Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainer,
              foregroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_pin,
                      color: AppColors.primary, size: 36),
                  SizedBox(height: 8),
                  Text('Map Preview',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Field(
              controller: _addressCtrl,
              label: 'Full Address',
              hint: 'House no, Street, Area'),
          const SizedBox(height: 12),
          _Field(
              controller: _landmarkCtrl,
              label: 'Landmark',
              hint: 'Near school, temple, etc.'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _Field(
                      controller: _cityCtrl,
                      label: 'City',
                      hint: 'Bangalore')),
              const SizedBox(width: 12),
              Expanded(
                  child: _Field(
                      controller: _pincodeCtrl,
                      label: 'Pincode',
                      hint: '560034',
                      keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Save Address',
            icon: Icons.save_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address saved!')),
              );
              context.pop();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.onSurfaceVariant),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
