import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';

const _faqs = {
  'General': [
    ('What is Ecomins?', 'Ecomins is a 10-minute eco-friendly home services platform connecting you with verified green workers.'),
    ('How does 10-min delivery work?', 'We have workers stationed nearby. Once you book, the nearest available worker is dispatched immediately.'),
    ('Is Ecomins available in my city?', 'We currently serve Bangalore, Mumbai, Delhi, Chennai, Hyderabad, and Pune.'),
    ('Are the products eco-friendly?', 'Yes! All our cleaning products are biodegradable and certified eco-friendly.'),
    ('How do I earn eco points?', 'You earn eco points for every service booked. More eco-friendly services earn more points.'),
  ],
  'Booking': [
    ('Can I reschedule?', 'Yes, you can reschedule up to 2 hours before the scheduled time from the Orders screen.'),
    ('What if the worker doesn\'t arrive?', 'We guarantee a replacement within 10 minutes or a full refund.'),
    ('Can I book for a specific time?', 'Yes, use Smart Scheduling to pick your preferred date and time slot.'),
    ('How do I cancel a booking?', 'Go to Orders → tap your booking → Cancel. Cancellations before 1 hour are free.'),
    ('Can I book recurring services?', 'Yes! Use the Subscribe & Save feature for weekly or monthly recurring bookings.'),
  ],
  'Payment': [
    ('What payment methods are accepted?', 'UPI, credit/debit cards, net banking, and Ecomins Wallet.'),
    ('What is the refund policy?', 'Full refund if cancelled 1 hour before. 50% refund for same-day cancellations.'),
    ('Is my payment information secure?', 'Yes, all payments are processed through PCI-DSS compliant gateways.'),
    ('Can I pay with eco points?', 'Yes! Redeem eco points for discounts on future bookings.'),
    ('Are there any hidden charges?', 'No hidden charges. The price shown includes all taxes and platform fees.'),
  ],
  'Workers': [
    ('Are workers background verified?', 'Yes, all workers undergo police verification and identity checks.'),
    ('What training do workers receive?', 'Workers complete our Eco Certification program covering green practices and safety.'),
    ('Can I request a specific worker?', 'Yes, you can favourite workers and request them for future bookings.'),
    ('What if I\'m not satisfied?', 'We offer a free re-service within 24 hours if you\'re not satisfied.'),
    ('Do workers bring their own equipment?', 'Yes, workers bring all necessary eco-certified equipment and products.'),
  ],
  'Eco': [
    ('What is the eco impact of my bookings?', 'Each booking reduces CO₂ emissions. Track your impact in the Eco Hub.'),
    ('How are carbon credits calculated?', 'Based on the eco-friendliness of services and waste diverted from landfills.'),
    ('What can I do with eco points?', 'Redeem for vouchers, plant trees, get eco products, or donate to causes.'),
    ('How does tree planting work?', 'For every 200 eco points, we plant a tree in your name in a local forest.'),
    ('What is the Eco Streak?', 'Book eco services consecutively to build a streak and earn bonus points.'),
  ],
};

class ServiceFaqScreen extends StatefulWidget {
  const ServiceFaqScreen({super.key});

  @override
  State<ServiceFaqScreen> createState() => _ServiceFaqScreenState();
}

class _ServiceFaqScreenState extends State<ServiceFaqScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _query = '';
  int _expanded = -1;

  final _categories = _faqs.keys.toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() => setState(() => _expanded = -1));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Service FAQs'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                hintStyle:
                    const TextStyle(color: AppColors.onSurfaceVariant),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.outline),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((c) {
                final faqItems = (_faqs[c] ?? [])
                    .where((f) =>
                        _query.isEmpty ||
                        f.$1
                            .toLowerCase()
                            .contains(_query.toLowerCase()) ||
                        f.$2
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                    .toList();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: faqItems.length + 1,
                  itemBuilder: (context, i) {
                    if (i == faqItems.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/profile/help'),
                          icon: const Icon(Icons.headset_mic_outlined),
                          label: const Text('Still have questions?'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                                color: AppColors.primary),
                            minimumSize:
                                const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                        ),
                      );
                    }
                    final faq = faqItems[i];
                    final isOpen = _expanded == i;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: isOpen,
                        onExpansionChanged: (v) =>
                            setState(() => _expanded = v ? i : -1),
                        title: Text(
                          faq.$1,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        iconColor: AppColors.primary,
                        collapsedIconColor: AppColors.outline,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 16),
                            child: Text(
                              faq.$2,
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
