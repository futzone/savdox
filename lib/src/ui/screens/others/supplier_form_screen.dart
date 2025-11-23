import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/suplier_model/suplier.dart';
import 'package:savdox/src/core/repositories/suplier_repository.dart';
import 'package:savdox/src/core/providers/others_providers.dart';

final suplierRepositoryProvider = Provider((ref) => SuplierRepository());

class SupplierFormScreen extends HookConsumerWidget {
  final Suplier? supplier;

  const SupplierFormScreen({super.key, this.supplier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final fullnameController = useTextEditingController(
      text: supplier?.fullname ?? '',
    );
    final phoneController = useTextEditingController(
      text: supplier?.phone ?? '',
    );
    final addressController = useTextEditingController(
      text: supplier?.address ?? '',
    );
    final descriptionController = useTextEditingController(
      text: supplier?.description ?? '',
    );

    final isLoading = useState(false);

    Future<void> saveSupplier() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      try {
        final repo = ref.read(suplierRepositoryProvider);
        final newSupplier = supplier ?? Suplier();

        newSupplier.fullname = fullnameController.text;
        newSupplier.phone = phoneController.text.isEmpty
            ? null
            : phoneController.text;
        newSupplier.address = addressController.text.isEmpty
            ? null
            : addressController.text;
        newSupplier.description = descriptionController.text.isEmpty
            ? null
            : descriptionController.text;
        newSupplier.status = Suplier.activeStatus;
        newSupplier.created = supplier?.created ?? DateTime.now();
        newSupplier.updated = DateTime.now();

        if (supplier == null) {
          await repo.createSuplier(newSupplier);
        } else {
          await repo.updateSuplier(newSupplier);
        }

        // Refresh suppliers list
        ref.read(supliersProvider.notifier).refresh();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                supplier == null
                    ? 'Supplier created successfully'
                    : 'Supplier updated successfully',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(supplier == null ? 'Add Supplier' : 'Edit Supplier'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: fullnameController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              enabled: !isLoading.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter company name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 3,
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                hintText: 'Additional notes about this supplier',
              ),
              maxLines: 3,
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isLoading.value ? null : saveSupplier,
              icon: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(supplier == null ? 'Create' : 'Update'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }
}
