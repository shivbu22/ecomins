import 'package:flutter/material.dart';

import 'package:ecomins/core/theme/app_colors.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const _quickActions = [
    {'icon': Icons.local_shipping_outlined, 'label': 'Track Order'},
    {'icon': Icons.cancel_outlined, 'label': 'Cancel Booking'},
    {'icon': Icons.payment_outlined, 'label': 'Payment Issue'},
    {'icon': Icons.flag_outlined, 'label': 'Report Problem'},
  ];

  static const _faqs = [
    _Faq(
      question: 'How do I book a service?',
      answer:
          'Browse services from the Home screen, select a service, choose a package and time slot, then confirm your booking. You\'ll receive a confirmation once a worker is assigned.',
    ),
    _Faq(
      question: 'How are eco points earned?',
      answer:
          'You earn eco points every time you book an eco-friendly service. Points are credited to your account after the service is completed. Redeem them in the Eco Hub rewards marketplace.',
    ),
    _Faq(
      question: 'Can I cancel or reschedule a booking?',
      answer:
          'You can cancel or reschedule a booking up to 2 hours before the scheduled time. Go to My Orders, select the booking, and choose Cancel or Reschedule.',
    ),
    _Faq(
      question: 'How do I contact a worker?',
      answer:
          'Once a worker is assigned to your booking, you can call or chat with them directly from the Live Tracking screen.',
    ),
    _Faq(
      question: 'What payment methods are accepted?',
      answer:
          'We accept UPI, credit/debit cards, and Ecomins Wallet. You can manage your payment methods from the Profile section.',
    ),
  ];

  List<_Faq> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs
        .where((f) =>
            f.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            f.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.onSurface),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Search for help...',
                hintStyle: TextStyle(color: AppColors.outline),
                prefixIcon:
                    Icon(Icons.search, color: AppColors.outline),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick actions
          if (_searchQuery.isEmpty) ...[
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _quickActions.length,
              itemBuilder: (context, index) {
                final action = _quickActions[index];
                return GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${action['label']} coming soon')),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          action['icon'] as IconData,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],

          // FAQ accordion
          Text(
            _searchQuery.isEmpty ? 'FAQs' : 'Search Results',
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (_filteredFaqs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No results found',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ),
            )
          else
            ..._filteredFaqs.map((faq) => _FaqTile(faq: faq)),
          const SizedBox(height: 24),

          // Contact support
          const Text(
            'Still need help?',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening chat support...')),
              ),
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Chat with Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling support...')),
                  ),
                  icon: const Icon(Icons.phone_outlined, size: 16),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email...')),
                  ),
                  icon: const Icon(Icons.email_outlined, size: 16),
                  label: const Text('Email'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.faq});

  final _Faq faq;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            widget.faq.question,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            color: AppColors.outline,
          ),
          onExpansionChanged: (v) => setState(() => _expanded = v),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.faq.answer,
                style: const TextStyle(
                    color: AppColors.onSurfaceVariant, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Faq {
  const _Faq({required this.question, required this.answer});

  final String question;
  final String answer;
}
