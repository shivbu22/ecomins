import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_decorations.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/app_utils.dart';
import 'package:ecomins/data/models/service_model.dart';
import 'package:ecomins/data/mock/mock_data.dart';

/// Search history provider (last 5 searches)
final _searchHistoryProvider = StateProvider<List<String>>((ref) => []);

/// Production search screen with debounce, history, and filter bottom sheet.
class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  // ignore: prefer_final_fields
  String _filterCategory = 'All';
  bool _ecoOnly = false;
  String _sortBy = 'Relevance';

  List<ServiceModel> get _allServices {
    final all = <ServiceModel>[];
    for (final services in MockData.servicesByCategory.values) {
      all.addAll(services);
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = _searchController.text.trim());
    });
  }

  void _saveSearch(String query) {
    if (query.isEmpty) return;
    final history = List<String>.from(ref.read(_searchHistoryProvider));
    history.remove(query);
    history.insert(0, query);
    if (history.length > 5) history.removeLast();
    ref.read(_searchHistoryProvider.notifier).state = history;
  }

  List<ServiceModel> get _filteredResults {
    if (_query.isEmpty) return [];
    var results = _allServices.where((s) {
      final matchesQuery = s.name.toLowerCase().contains(_query.toLowerCase()) ||
          s.description.toLowerCase().contains(_query.toLowerCase());
      final matchesEco = !_ecoOnly || s.isEcoFriendly;
      final matchesCategory = _filterCategory == 'All' ||
          s.categoryId == _filterCategory.toLowerCase();
      return matchesQuery && matchesEco && matchesCategory;
    }).toList();

    switch (_sortBy) {
      case 'Price ↑':
        results.sort((a, b) => a.basePrice.compareTo(b.basePrice));
        break;
      case 'Price ↓':
        results.sort((a, b) => b.basePrice.compareTo(a.basePrice));
        break;
      case 'Rating ↓':
        results.sort((a, b) => b.avgRating.compareTo(a.avgRating));
        break;
    }
    return results;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(
        ecoOnly: _ecoOnly,
        sortBy: _sortBy,
        onApply: (ecoOnly, sortBy) {
          setState(() {
            _ecoOnly = ecoOnly;
            _sortBy = sortBy;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(_searchHistoryProvider);
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: 'Search eco services...',
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.outline),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.outline),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
          onSubmitted: (v) => _saveSearch(v.trim()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined, color: AppColors.onSurface),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _query.isEmpty
          ? _EmptySearchState(
              history: history,
              onHistoryTap: (q) {
                _searchController.text = q;
                setState(() => _query = q);
              },
            )
          : results.isEmpty
              ? _NoResultsState(query: _query)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) => _ServiceResultCard(
                    service: results[index],
                    onTap: () {
                      _saveSearch(_query);
                      context.push(
                          '/services/${results[index].categoryId}/${results[index].id}');
                    },
                  ),
                ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.history, required this.onHistoryTap});

  final List<String> history;
  final void Function(String) onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (history.isNotEmpty) ...[
          Text('Recent Searches', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: history
                .map((q) => GestureDetector(
                      onTap: () => onHistoryTap(q),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: AppDecorations.chip(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history,
                                size: 14, color: AppColors.outline),
                            const SizedBox(width: 6),
                            Text(q, style: AppTextStyles.chip),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text('Popular Services', style: AppTextStyles.h4),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Cleaning', 'Recycling', 'Garbage', 'Deep Clean', 'Garden']
              .map((s) => GestureDetector(
                    onTap: () => onHistoryTap(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: AppDecorations.chip(isSelected: false),
                      child: Text(s, style: AppTextStyles.chip),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_outlined,
              size: 64, color: AppColors.outline),
          const SizedBox(height: 16),
          Text('No results for "$query"',
              style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text('Try a different keyword or browse categories',
              style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.push('/services/cleaning'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Browse Services',
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceResultCard extends StatelessWidget {
  const _ServiceResultCard({required this.service, required this.onTap});

  final ServiceModel service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card(),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(service.iconAsset,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: AppTextStyles.h4),
                  const SizedBox(height: 2),
                  Text(service.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFC107), size: 12),
                      const SizedBox(width: 3),
                      Text(service.avgRating.toStringAsFixed(1),
                          style: AppTextStyles.caption),
                      if (service.isEcoFriendly) ...[
                        const SizedBox(width: 8),
                        const Text('🌿',
                            style: TextStyle(fontSize: 11)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Text(
              AppUtils.formatCurrency(service.basePrice),
              style: AppTextStyles.price.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.ecoOnly,
    required this.sortBy,
    required this.onApply,
  });

  final bool ecoOnly;
  final String sortBy;
  final void Function(bool ecoOnly, String sortBy) onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late bool _ecoOnly;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _ecoOnly = widget.ecoOnly;
    _sortBy = widget.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter & Sort', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          Text('Sort By', style: AppTextStyles.h4),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: ['Relevance', 'Price ↑', 'Price ↓', 'Rating ↓']
                .map((s) => GestureDetector(
                      onTap: () => setState(() => _sortBy = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: AppDecorations.chip(isSelected: _sortBy == s),
                        child: Text(s,
                            style: AppTextStyles.chip.copyWith(
                                color: _sortBy == s
                                    ? AppColors.primary
                                    : AppColors.onSurface)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text('Eco-Friendly Only', style: AppTextStyles.body),
              ),
              Switch(
                value: _ecoOnly,
                onChanged: (v) => setState(() => _ecoOnly = v),
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_ecoOnly, _sortBy);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
