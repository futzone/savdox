import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/providers/others_providers.dart';

class CustomersScreen extends HookConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final customersAsync = ref.watch(customersProvider);
    final theme = Theme.of(context);

    // Debounce search
    useEffect(() {
      void listener() {
        ref.read(customerSearchQueryProvider.notifier).state =
            searchController.text;
        ref.read(customersProvider.notifier).refresh();
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add customer functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Customer coming soon')),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: customersAsync.when(
              data: (customers) {
                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No customers found',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: customers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == customers.length) {
                      if (ref.read(customersProvider.notifier).hasMore) {
                        ref.read(customersProvider.notifier).loadMore();
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox(height: 20);
                    }
                    final customer = customers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          customer.fullname.isNotEmpty
                              ? customer.fullname[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(customer.fullname),
                      subtitle: Text(
                        customer.phone ?? customer.email ?? 'No contact info',
                      ),
                      onTap: () {
                        // TODO: Show customer details/edit
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
      ),
    );
  }
}
