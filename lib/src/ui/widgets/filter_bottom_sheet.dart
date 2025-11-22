import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/providers/product_providers.dart';

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentFilters = ref.watch(productFiltersProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ref.read(productFiltersProvider.notifier).state =
                      ProductFilters();
                  ref.read(productsProvider.notifier).refresh();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Category Filter
          Text(
            'Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                return const Text('No categories available');
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: currentFilters.category == null,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(productFiltersProvider.notifier).state =
                            currentFilters.copyWith(category: null);
                      }
                    },
                  ),
                  ...categories.map((category) {
                    return FilterChip(
                      label: Text(category),
                      selected: currentFilters.category == category,
                      onSelected: (selected) {
                        ref.read(productFiltersProvider.notifier).state =
                            currentFilters.copyWith(
                          category: selected ? category : null,
                        );
                      },
                    );
                  }),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => const Text('Error loading categories'),
          ),
          
          const SizedBox(height: 24),
          
          // Status Filter
          Text(
            'Status',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Active'),
                selected: currentFilters.status == 'active' ||
                    currentFilters.status == null,
                onSelected: (selected) {
                  ref.read(productFiltersProvider.notifier).state =
                      currentFilters.copyWith(status: 'active');
                },
              ),
              FilterChip(
                label: const Text('Archived'),
                selected: currentFilters.status == 'archived',
                onSelected: (selected) {
                  ref.read(productFiltersProvider.notifier).state =
                      currentFilters.copyWith(
                    status: selected ? 'archived' : 'active',
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref.read(productsProvider.notifier).refresh();
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
