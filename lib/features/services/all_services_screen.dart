import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/data/models/service_model.dart';
import 'package:ecomins/features/home/widgets/service_card_widget.dart';
import 'package:ecomins/providers/service_providers.dart';

/// All Services browse screen with search, filter, sort, and infinite scroll.
class AllServicesScreen extends ConsumerStatefulWidget {
  const AllServicesScreen({super.key});

  @override
  ConsumerState<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends ConsumerState<AllServicesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'All';
  String _sort = 'Relevance';
  int _loadedCount = 10;

  static const _filters = ['All', 'Eco-Friendly', 'Top Rated', 'Lowest Price'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceModel> _applyFiltersAndSort(List<ServiceModel> all) {
    var results = all.where((s) {
      final matchesQuery = _query.isEmpty ||
          s.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Eco-Friendly' && s.isEcoFriendly);
      return matchesQuery && matchesFilter;
    }).toList();

    switch (_sort) {
      case 'Price ↑':
        results.sort((a, b) => a.basePrice.compareTo(b.basePrice));
        break;
      case 'Price ↓':
        results.sort((a, b) => b.basePrice.compareTo(a.basePrice));
        break;
      case 'Rating ↑↓':
        results.sort((a, b) => b.avgRating.compareTo(a.avgRating));
        break;
      case 'Lowest Price':
        results.sort((a, b) => a.basePrice.compareTo(b.basePrice));
        break;
      case 'Top Rated':
        results.sort((a, b) => b.avgRating.compareTo(a.avgRating));
        break;
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final allServices = ref.watch(allServicesProvider);
    final filtered = _applyFiltersAndSort(allServices);
    final displayed = filtered.take(_loadedCount).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        title: Text('All Services', style: AppTextStyles.h3),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: AppColors.onSurface),
            color: AppColors.surfaceContainerLow,
            onSelected: (v) => setState(() => _sort = v),
            itemBuilder: (_) => ['Relevance', 'Price ↑', 'Price ↓', 'Rating ↑↓']
                .map((s) => PopupMenuItem(
                      value: s,
                      child: Text(s, style: AppTextStyles.body),
                    ))
                .toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          setState(() => _loadedCount = 10);
        },
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.outline),
                  prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),

            // Filter chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final f = _filters[i];
                  final isSelected = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: AppDecorations.chip(isSelected: isSelected),
                      child: Text(f,
                          style: AppTextStyles.chip.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.onSurface)),
                    ),
                  );
                },
              ),
            ),

            // Results
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text('No services found',
                          style: AppTextStyles.bodySmall),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: displayed.length + 1,
                      itemBuilder: (context, index) {
                        if (index == displayed.length) {
                          if (_loadedCount >= filtered.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '${filtered.length} services found',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall,
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _loadedCount += 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text('Load more',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.primary)),
                              ),
                            ),
                          );
                        }
                        final service = displayed[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ServiceCardWidget(
                            service: service,
                            onTap: () => context.push(
                                '/services/${service.categoryId}/${service.id}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
