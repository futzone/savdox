import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/providers/billing_providers.dart';
import 'package:savdox/src/ui/widgets/shopping_list_item.dart';
import 'package:savdox/src/ui/widgets/transaction_list_item.dart';

class BillingScreen extends HookConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.receipt), text: 'Transactions'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [_TransactionsTab(), _ShoppingTab()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show dialog to add transaction or shopping based on current tab
          // For now, just a placeholder action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add feature coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TransactionsTab extends HookConsumerWidget {
  const _TransactionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final transactionsAsync = ref.watch(transactionsProvider);
    final theme = Theme.of(context);

    // Debounce search
    useEffect(() {
      void listener() {
        // Simple debounce could be added here, for now updating directly
        // In a real app, use a timer to debounce
        ref.read(transactionSearchQueryProvider.notifier).state =
            searchController.text;
        ref.read(transactionsProvider.notifier).refresh();
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: () {
                  // TODO: Show filter bottom sheet
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ),
        Expanded(
          child: transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: transactions.length + 1,
                itemBuilder: (context, index) {
                  if (index == transactions.length) {
                    if (ref.read(transactionsProvider.notifier).hasMore) {
                      ref.read(transactionsProvider.notifier).loadMore();
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox(height: 80); // Bottom padding for FAB
                  }
                  return TransactionListItem(
                    transaction: transactions[index],
                    onTap: () {
                      // TODO: Show transaction details
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}

class _ShoppingTab extends HookConsumerWidget {
  const _ShoppingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final shoppingListAsync = ref.watch(shoppingListProvider);
    final theme = Theme.of(context);

    // Debounce search
    useEffect(() {
      void listener() {
        ref.read(shoppingSearchQueryProvider.notifier).state =
            searchController.text;
        ref.read(shoppingListProvider.notifier).refresh();
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search shopping...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                onPressed: () {
                  // TODO: Show filter bottom sheet
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ),
        Expanded(
          child: shoppingListAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No shopping items found',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    if (ref.read(shoppingListProvider.notifier).hasMore) {
                      ref.read(shoppingListProvider.notifier).loadMore();
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox(height: 80); // Bottom padding for FAB
                  }
                  return ShoppingListItem(
                    shopping: items[index],
                    onTap: () {
                      // TODO: Show shopping details
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}
