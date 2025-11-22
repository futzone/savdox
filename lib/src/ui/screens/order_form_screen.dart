import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/order_model/order.dart';
import 'package:savdox/src/core/models/product_model/product.dart';
import 'package:savdox/src/core/providers/home_providers.dart';
import 'package:savdox/src/ui/widgets/product_selection_sheet.dart';

class OrderFormScreen extends HookConsumerWidget {
  final Order? order;

  const OrderFormScreen({super.key, this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Form Controllers
    final customerController = useTextEditingController(
      text: order?.customerId?.toString() ?? '',
    );
    final statusController = useTextEditingController(
      text: order?.status ?? Order.activeStatus,
    );

    // State
    final items = useState<List<OrderItem>>(order?.items.toList() ?? []);
    final isLoading = useState(false);

    // Calculate total sum
    final totalSum = useMemoized(() {
      return items.value.fold<double>(
        0,
        (sum, item) => sum + (item.unitPrice * item.amount),
      );
    }, [items.value]);

    Future<void> saveOrder() async {
      if (!formKey.currentState!.validate()) return;
      if (items.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one product')),
        );
        return;
      }

      isLoading.value = true;
      try {
        final repo = ref.read(orderRepositoryProvider);
        final newOrder = order ?? Order();

        newOrder.customerId = int.tryParse(customerController.text);
        newOrder.status = statusController.text;
        newOrder.items = items.value;
        newOrder.totalSum = totalSum;
        newOrder.finalSum = totalSum; // Can apply discount logic here later
        newOrder.created = order?.created ?? DateTime.now();
        newOrder.updated = DateTime.now();

        if (order == null) {
          await repo.createOrder(newOrder);
        } else {
          await repo.updateOrder(newOrder);
        }

        // Refresh recent orders list
        ref.read(recentOrdersProvider.notifier).refresh();

        // Refresh dashboard Stats
        ref.invalidate(dashboardStatsProvider);

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                order == null
                    ? 'Order created successfully'
                    : 'Order updated successfully',
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

    void showProductSelection() async {
      final Product? product = await showModalBottomSheet<Product>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const ProductSelectionSheet(),
      );

      if (product != null) {
        // Check if product already exists in items
        final existingIndex = items.value.indexWhere(
          (item) => item.productId == product.id,
        );

        if (existingIndex != -1) {
          // Increment amount
          final updatedItems = List<OrderItem>.from(items.value);
          updatedItems[existingIndex].amount += 1;
          items.value = updatedItems;
        } else {
          // Add new item
          final newItem = OrderItem()
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
      final updatedItems = List<OrderItem>.from(items.value);
      final item = updatedItems[index];
      final newAmount = item.amount + delta;

      if (newAmount <= 0) {
        updatedItems.removeAt(index);
      } else {
        item.amount = newAmount;
      }
      items.value = updatedItems;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(order == null ? 'Add Order' : 'Edit Order'),
        actions: [
          if (isLoading.value)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: saveOrder,
              tooltip: 'Save',
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Customer & Status Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: customerController,
                            decoration: const InputDecoration(
                              labelText: 'Customer ID',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            keyboardType: TextInputType.number,
                            enabled: !isLoading.value,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: statusController,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.info),
                            ),
                            enabled: !isLoading.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Items Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Items',
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
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No items added',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
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
                            subtitle: Text(
                              '${item.amount} x \$${item.unitPrice.toStringAsFixed(2)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${(item.amount * item.unitPrice).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => updateItemAmount(index, -1),
                                  color: theme.colorScheme.error,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => updateItemAmount(index, 1),
                                  color: theme.colorScheme.primary,
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

            // Total Footer
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount:', style: theme.textTheme.titleMedium),
                    Text(
                      '\$${totalSum.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
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
