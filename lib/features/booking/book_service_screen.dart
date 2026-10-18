import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/data/models/models.dart';
import 'package:ecomins/data/mock/mock_data.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/providers/booking_providers.dart';
import 'package:ecomins/providers/service_providers.dart';

class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  ConsumerState<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends ConsumerState<BookServiceScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  static const int _totalSteps = 5;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: _prevStep,
        ),
        title: const Text(
          'Book Service',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _StepIndicator(currentStep: _currentStep, totalSteps: _totalSteps),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _Step1PackagePicker(serviceId: widget.serviceId, onNext: _nextStep),
          _Step2AddressSelector(onNext: _nextStep),
          _Step3Schedule(onNext: _nextStep),
          _Step4PaymentMethod(onNext: _nextStep),
          _Step5Summary(
            serviceId: widget.serviceId,
            isSubmitting: _isSubmitting,
            onConfirm: _submitBooking,
          ),
        ],
      ),
    );
  }

  Future<void> _submitBooking() async {
    final formState = ref.read(bookingFormProvider);
    final isLoggedIn = ref.read(authStateProvider);
    final currentUser = ref.read(currentUserProvider);

    if (formState.selectedPackage == null ||
        formState.selectedAddress == null ||
        formState.scheduleConfig == null ||
        formState.paymentMethod == null ||
        !isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all steps before confirming.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final pkg = formState.selectedPackage!;
      final address = formState.selectedAddress!;
      final schedule = formState.scheduleConfig!;
      final paymentMethod = formState.paymentMethod!;

      const platformFee = 19.0;
      final service = ref.read(serviceByIdProvider(widget.serviceId));
      final isEco = service?.isEcoFriendly ?? false;
      const ecoDiscount = 50.0;
      final total = pkg.price + platformFee - (isEco ? ecoDiscount : 0);

      final booking = BookingModel(
        id: '',
        userId: currentUser.uid,
        serviceId: widget.serviceId,
        serviceName: service?.name ?? 'Service',
        serviceIcon: service?.iconAsset ?? '🧹',
        workerId: MockData.workers.isNotEmpty ? MockData.workers.first.id : '',
        status: BookingStatus.workerAssigned,
        serviceAddress: address,
        scheduledAt: schedule.scheduledAt ?? DateTime.now(),
        totalAmount: total,
        paymentMethod: paymentMethod,
        scheduleConfig: schedule,
      );

      final bookingService = ref.read(bookingRepositoryProvider);
      final bookingId = await bookingService.createBooking(booking);

      ref.read(bookingFormProvider.notifier).reset();

      if (mounted) {
        context.go('/booking/$bookingId/confirmed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

// ── Step Indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isDone = index < currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDone || isActive
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < totalSteps - 1) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Step 1: Package Picker ────────────────────────────────────────────────────

class _Step1PackagePicker extends ConsumerWidget {
  const _Step1PackagePicker({required this.serviceId, required this.onNext});

  final String serviceId;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(serviceByIdProvider(serviceId));
    final formState = ref.watch(bookingFormProvider);

    if (service == null) {
      return const Center(
        child: Text('Service not found', style: TextStyle(color: AppColors.onSurfaceVariant)),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x333C4A3C)),
                  ),
                  child: Row(
                    children: [
                      Text(service.iconAsset, style: const TextStyle(fontSize: 36)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.name,
                                style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${service.basePrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star, color: Color(0xFFFFC107), size: 13),
                                const SizedBox(width: 3),
                                Text(service.avgRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                        color: AppColors.onSurfaceVariant, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select Package',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                if (service.packages.isEmpty)
                  const Text('No packages available',
                      style: TextStyle(color: AppColors.onSurfaceVariant))
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: service.packages.length,
                    itemBuilder: (context, index) {
                      final pkg = service.packages[index];
                      final isActive = formState.selectedPackage?.id == pkg.id;
                      return GestureDetector(
                        onTap: () =>
                            ref.read(bookingFormProvider.notifier).setPackage(pkg),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0x1A3FE56C)
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive ? AppColors.primary : const Color(0x333C4A3C),
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pkg.name,
                                style: TextStyle(
                                  color: isActive ? AppColors.primary : AppColors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${pkg.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        _BottomNextButton(
          label: 'Next',
          enabled: formState.selectedPackage != null,
          onTap: onNext,
        ),
      ],
    );
  }
}

// ── Step 2: Address Selector ──────────────────────────────────────────────────

class _Step2AddressSelector extends ConsumerWidget {
  const _Step2AddressSelector({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final formState = ref.watch(bookingFormProvider);
    final addresses = user.savedAddresses;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Select Address',
                  style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...addresses.map((addr) {
                final isSelected = formState.selectedAddress?.id == addr.id;
                return GestureDetector(
                  onTap: () =>
                      ref.read(bookingFormProvider.notifier).setAddress(addr),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0x1A3FE56C)
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0x333C4A3C),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                            size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addr.label,
                                  style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(addr.fullAddress,
                                  style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add address coming soon')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x333C4A3C)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_location_alt_outlined,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Text('Add new address',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _BottomNextButton(
          label: 'Next',
          enabled: formState.selectedAddress != null,
          onTap: onNext,
        ),
      ],
    );
  }
}

// ── Step 3: Schedule ──────────────────────────────────────────────────────────

class _Step3Schedule extends ConsumerWidget {
  const _Step3Schedule({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bookingFormProvider);

    final options = [
      const _ScheduleOption(
        icon: '⚡',
        label: 'Now',
        subtitle: 'Immediate',
        config: ScheduleConfig(type: ScheduleType.immediate),
      ),
      _ScheduleOption(
        icon: '⏱',
        label: 'In 30 min',
        subtitle: 'Scheduled',
        config: ScheduleConfig(
          type: ScheduleType.scheduled,
          scheduledAt: DateTime.now().add(const Duration(minutes: 30)),
        ),
      ),
      _ScheduleOption(
        icon: '🌅',
        label: 'Today PM',
        subtitle: 'Afternoon',
        config: ScheduleConfig(
          type: ScheduleType.scheduled,
          scheduledAt: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            15,
            0,
          ),
        ),
      ),
      _ScheduleOption(
        icon: '📅',
        label: 'Tomorrow',
        subtitle: 'Morning',
        config: ScheduleConfig(
          type: ScheduleType.scheduled,
          scheduledAt: DateTime.now()
              .add(const Duration(days: 1))
              .copyWith(hour: 9, minute: 0, second: 0),
        ),
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('When do you need it?',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: options.map((opt) {
                    final isSelected =
                        formState.scheduleConfig?.type == opt.config.type &&
                            formState.scheduleConfig?.scheduledAt ==
                                opt.config.scheduledAt;
                    return GestureDetector(
                      onTap: () => ref
                          .read(bookingFormProvider.notifier)
                          .setScheduleConfig(opt.config),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0x1A3FE56C)
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0x333C4A3C),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(opt.icon, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(opt.label,
                                style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            Text(opt.subtitle,
                                style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        _BottomNextButton(
          label: 'Next',
          enabled: formState.scheduleConfig != null,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _ScheduleOption {
  const _ScheduleOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.config,
  });

  final String icon;
  final String label;
  final String subtitle;
  final ScheduleConfig config;
}

// ── Step 4: Payment Method ────────────────────────────────────────────────────

class _Step4PaymentMethod extends ConsumerWidget {
  const _Step4PaymentMethod({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bookingFormProvider);
    final user = ref.watch(currentUserProvider);
    final walletBalance = user.wallet.balance;

    final methods = [
      const _PaymentOption(id: 'upi', icon: '📱', label: 'UPI'),
      _PaymentOption(
          id: 'wallet',
          icon: '👛',
          label: 'Wallet',
          subtitle: '₹${walletBalance.toStringAsFixed(0)} available'),
      const _PaymentOption(id: 'card', icon: '💳', label: 'Card'),
      const _PaymentOption(id: 'cash', icon: '💵', label: 'Cash'),
    ];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Payment Method',
                  style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...methods.map((method) {
                final isSelected = formState.paymentMethod == method.id;
                return GestureDetector(
                  onTap: () => ref
                      .read(bookingFormProvider.notifier)
                      .setPaymentMethod(method.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0x1A3FE56C)
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0x333C4A3C),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(method.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(method.label,
                                  style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              if (method.subtitle != null)
                                Text(method.subtitle!,
                                    style: const TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 13)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        _BottomNextButton(
          label: 'Next',
          enabled: formState.paymentMethod != null,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _PaymentOption {
  const _PaymentOption({required this.id, required this.icon, required this.label, this.subtitle});
  final String id;
  final String icon;
  final String label;
  final String? subtitle;
}

// ── Step 5: Summary ───────────────────────────────────────────────────────────

class _Step5Summary extends ConsumerWidget {
  const _Step5Summary({
    required this.serviceId,
    required this.isSubmitting,
    required this.onConfirm,
  });

  final String serviceId;
  final bool isSubmitting;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bookingFormProvider);
    final service = ref.watch(serviceByIdProvider(serviceId));
    final pkg = formState.selectedPackage;
    final address = formState.selectedAddress;
    final schedule = formState.scheduleConfig;
    final payment = formState.paymentMethod;

    const platformFee = 19.0;
    final isEco = service?.isEcoFriendly ?? false;
    const ecoDiscount = 50.0;
    final total = (pkg?.price ?? 0) + platformFee - (isEco ? ecoDiscount : 0);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Summary',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                _SummaryRow(label: 'Service', value: service?.name ?? '-'),
                _SummaryRow(label: 'Package', value: pkg?.name ?? '-'),
                _SummaryRow(label: 'Address', value: address?.label ?? '-'),
                _SummaryRow(
                    label: 'Schedule',
                    value: schedule?.type == ScheduleType.immediate
                        ? 'Now'
                        : 'Scheduled'),
                _SummaryRow(label: 'Payment', value: payment ?? '-'),
                const Divider(color: AppColors.outline, height: 24),
                _SummaryRow(
                    label: 'Service Price',
                    value: '₹${pkg?.price.toStringAsFixed(0) ?? '0'}'),
                _SummaryRow(label: 'Platform Fee', value: '₹${platformFee.toStringAsFixed(0)}'),
                if (isEco)
                  _SummaryRow(
                      label: 'Eco Discount',
                      value: '-₹${ecoDiscount.toStringAsFixed(0)}',
                      valueColor: AppColors.primary),
                const Divider(color: AppColors.outline, height: 24),
                _SummaryRow(
                    label: 'Total',
                    value: '₹${total.toStringAsFixed(0)}',
                    isBold: true),
              ],
            ),
          ),
        ),
        _BottomNextButton(
          label: isSubmitting ? 'Confirming...' : 'Confirm Booking',
          enabled: !isSubmitting,
          onTap: onConfirm,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, fontSize: 14)),
          Text(value,
              style: TextStyle(
                color: valueColor ?? AppColors.onSurface,
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

// ── Bottom Next Button ────────────────────────────────────────────────────────

class _BottomNextButton extends StatelessWidget {
  const _BottomNextButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Color(0x333C4A3C))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
