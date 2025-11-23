import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/providers/others_providers.dart';
import 'package:savdox/src/ui/screens/others/supplier_form_screen.dart';

class SuppliersScreen extends HookConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final supliersAsync = ref.watch(supliersProvider);
    final theme = Theme.of(context);

    // Debounce search
    useEffect(() {
      void listener() {
        ref.read(suplierSearchQueryProvider.notifier).state =
            searchController.text;
        ref.read(supliersProvider.notifier).refresh();
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupplierFormScreen()),
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
                hintText: 'Search suppliers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: supliersAsync.when(
              data: (supliers) {
                if (supliers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No suppliers found',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: supliers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == supliers.length) {
                      if (ref.read(supliersProvider.notifier).hasMore) {
                        ref.read(supliersProvider.notifier).loadMore();
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox(height: 20);
                    }
                    final suplier = supliers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          suplier.fullname.isNotEmpty
                              ? suplier.fullname[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(suplier.fullname),
                      subtitle: Text(suplier.phone ?? 'No contact info'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                SupplierFormScreen(supplier: suplier),
                          ),
                        );
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
