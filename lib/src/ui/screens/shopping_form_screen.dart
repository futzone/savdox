import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:savdox/src/core/models/shopping_model/shopping.dart';
import 'package:savdox/src/core/models/product_model/product.dart';
import 'package:savdox/src/core/models/suplier_model/suplier.dart';
import 'package:savdox/src/core/repositories/shopping_repository.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/providers/billing_providers.dart';
import 'package:savdox/src/ui/widgets/product_selection_sheet.dart';
import 'package:savdox/src/ui/widgets/amount_input_dialog.dart';

final shoppingRepositoryProvider = Provider((ref) => ShoppingRepository());

// Supplier selection provider
final supplierSelectionProvider = FutureProvider.family<List<Suplier>, String>((
  ref,
  searchQuery,
) async {
  final isar = IsarDatabase.instance.isar;
  var query = isar.supliers.where().filter().idGreaterThan(-1);

  if (searchQuery.isNotEmpty) {
    query = query.fullnameContains(searchQuery, caseSensitive: false);
  }

  query = query.statusEqualTo(Suplier.activeStatus);
  return await query.limit(50).findAll();
});

class ShoppingFormScreen extends HookConsumerWidget {
  final Shopping? shopping;

  const ShoppingFormScreen({super.key, this.shopping});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final noteController = useTextEditingController(text: shopping?.note ?? '');

    final items = useState<List<ShoppingItem>>(shopping?.items.toList() ?? []);
    final selectedSupplier = useState<Suplier?>(null);
    final isLoading = useState(false);

    // Calculate totals
    final totalSum = useMemoized(() {
      return items.value.fold<double>(
        0,
        (sum, item) => sum + (item.unitPrice * item.amount),
      );
    }, [items.value]);

    Future<void> saveShopping() async {
      if (!formKey.currentState!.validate()) return;
      if (selectedSupplier.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a supplier')),
        );
        return;
      }
      if (items.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one product')),
        );
        return;
      }

      isLoading.value = true;
      try {
        final repo = ref.read(shoppingRepositoryProvider);
        final newShopping = shopping ?? Shopping();

        newShopping.supplierId = selectedSupplier.value!.id;
        newShopping.items = items.value;
        newShopping.totalSum = totalSum;
        newShopping.finalSum = totalSum; // Can apply discount later
        newShopping.note = noteController.text.isEmpty
            ? null
            : noteController.text;
        newShopping.status = Shopping.activeStatus;
        newShopping.created = shopping?.created ?? DateTime.now();
        newShopping.updated = DateTime.now();

        if (shopping == null) {
          await repo.createShopping(newShopping);
        } else {
          await repo.updateShopping(newShopping);
        }

        // Refresh shopping list
        ref.read(shoppingListProvider.notifier).refresh();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                shopping == null
                    ? 'Shopping created successfully'
                    : 'Shopping updated successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> selectSupplier() async {
      final searchController = TextEditingController();
      final searchQuery = ValueNotifier('');

      final Suplier? supplier = await showModalBottomSheet<Suplier>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (bottomSheetContext) => StatefulBuilder(
          builder: (context, setState) {
            final suppliersAsync = ref.watch(
              supplierSelectionProvider(searchQuery.value),
            );

            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search suppliers...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery.value = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: suppliersAsync.when(
                      data: (suppliers) {
                        if (suppliers.isEmpty) {
                          return const Center(
                            child: Text('No suppliers found'),
                          );
                        }
                        return ListView.builder(
                          itemCount: suppliers.length,
                          itemBuilder: (context, index) {
                            final supplier = suppliers[index];
                            return ListTile(
                              title: Text(supplier.fullname),
                              subtitle: Text(supplier.phone ?? ''),
                              onTap: () => Navigator.pop(context, supplier),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Center(child: Text('Error: $e')),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      if (supplier != null) {
        selectedSupplier.value = supplier;
      }
    }

    void showProductSelection() async {
      final Product? product = await showModalBottomSheet<Product>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const ProductSelectionSheet(),
      );

      if (product != null) {
        final existingIndex = items.value.indexWhere(
          (item) => item.productId == product.id,
        );

        if (existingIndex != -1) {
          final updatedItems = List<ShoppingItem>.from(items.value);
          updatedItems[existingIndex].amount += 1;
          items.value = updatedItems;
        } else {
          final newItem = ShoppingItem()
            ..productId = product.id
            ..name = product.name
            ..price = product.price
            ..unitPrice = product.price
            ..amount = 1.0;

          items.value = [...items.value, newItem];
        }
      }
    }

    void updateItemAmount(int index, double delta) {
      final updatedItems = List<ShoppingItem>.from(items.value);
      final item = updatedItems[index];
      final newAmount = item.amount + delta;

      if (newAmount <= 0) {
        updatedItems.removeAt(index);
      } else {
        item.amount = newAmount;
      }
      items.value = updatedItems;
    }

    Future<void> editItemAmount(int index) async {
      final item = items.value[index];
      final newAmount = await showDialog<double>(
        context: context,
        builder: (_) => AmountInputDialog(
          initialAmount: item.amount,
          title: 'Edit Amount for ${item.name}',
        ),
      );

      if (newAmount != null) {
        final updatedItems = List<ShoppingItem>.from(items.value);
        updatedItems[index].amount = newAmount;
        items.value = updatedItems;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(shopping == null ? 'Add Shopping' : 'Edit Shopping'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Supplier Selection
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.local_shipping),
                      title: const Text('Supplier *'),
                      subtitle: Text(
                        selectedSupplier.value?.fullname ?? 'Tap to select',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: isLoading.value ? null : selectSupplier,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Note
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 2,
                    enabled: !isLoading.value,
                  ),
                  const SizedBox(height: 24),

                  // Items Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Products',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: isLoading.value
                            ? null
                            : showProductSelection,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Items List
                  if (items.value.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('No products added'),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.value.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items.value[index];
                        return Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            title: Text(item.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unit Price: \$${item.unitPrice.toStringAsFixed(2)}',
                                ),
                                GestureDetector(
                                  onTap: () => editItemAmount(index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Qty: ${item.amount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: theme
                                                .colorScheme
                                                .onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: theme
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\$${(item.amount * item.unitPrice).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.add, size: 18),
                                        onPressed: () =>
                                            updateItemAmount(index, 1),
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            updateItemAmount(index, -1),
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                  ],
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

            // Total Footer with Save Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          '\$${totalSum.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: isLoading.value ? null : saveShopping,
                      icon: isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        shopping == null
                            ? 'Create Shopping'
                            : 'Update Shopping',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
