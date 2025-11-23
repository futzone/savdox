import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/customer_model/customer.dart';
import 'package:savdox/src/core/repositories/customer_repository.dart';

final customerSelectionProvider = FutureProvider.family<List<Customer>, String>(
  (ref, searchQuery) async {
    final repo = CustomerRepository();
    return await repo.getCustomers(
      offset: 0,
      limit: 50,
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
    );
  },
);

class CustomerSelectionSheet extends HookConsumerWidget {
  const CustomerSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final theme = Theme.of(context);

    // Debounce search
    useEffect(() {
      void listener() {
        searchQuery.value = searchController.text;
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    final customersAsync = ref.watch(
      customerSelectionProvider(searchQuery.value),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search customers...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                        autofocus: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: customersAsync.when(
                  data: (customers) {
                    if (customers.isEmpty) {
                      return Center(
                        child: Text(
                          'No customers found',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return ListTile(
                          title: Text(
                            customer.fullname,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(customer.phone ?? ''),
                          trailing: customer.totalOrders != null
                              ? Text(
                                  '${customer.totalOrders} orders',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          onTap: () {
                            Navigator.pop(context, customer);
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
