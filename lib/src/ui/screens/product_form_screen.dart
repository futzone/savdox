import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/product_model/product.dart';
import 'package:savdox/src/core/providers/product_providers.dart';

class ProductFormScreen extends HookConsumerWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController(text: product?.name ?? '');
    final priceController = useTextEditingController(
      text: product?.price.toString() ?? '',
    );
    final descriptionController = useTextEditingController(
      text: product?.description ?? '',
    );
    final barcodeController = useTextEditingController(
      text: product?.barcode ?? '',
    );
    final categoryController = useTextEditingController(
      text: product?.category ?? '',
    );
    final unitController = useTextEditingController(
      text: product?.unit ?? '',
    );

    final isLoading = useState(false);

    Future<void> saveProduct() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;

      try {
        final repository = ref.read(productRepositoryProvider);
        final newProduct = product ?? Product();

        newProduct.name = nameController.text;
        newProduct.price = double.parse(priceController.text);
        newProduct.description = descriptionController.text.isEmpty
            ? null
            : descriptionController.text;
        newProduct.barcode =
            barcodeController.text.isEmpty ? null : barcodeController.text;
        newProduct.category =
            categoryController.text.isEmpty ? null : categoryController.text;
        newProduct.unit =
            unitController.text.isEmpty ? null : unitController.text;

        if (product == null) {
          await repository.createProduct(newProduct);
        } else {
          await repository.updateProduct(newProduct);
        }

        ref.read(productsProvider.notifier).refresh();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                product == null
                    ? 'Product created successfully'
                    : 'Product updated successfully',
              ),
            ),
          );
        }
      } catch (e) {
        log("On CRUD product:", error: e);


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

    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
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
              onPressed: saveProduct,
              tooltip: 'Save',
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: barcodeController,
              decoration: const InputDecoration(
                labelText: 'Barcode',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'Unit (e.g., kg, pcs)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.scale),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isLoading.value ? null : saveProduct,
              icon: const Icon(Icons.save),
              label: Text(product == null ? 'Create Product' : 'Update Product'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
