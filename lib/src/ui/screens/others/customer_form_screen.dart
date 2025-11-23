import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/customer_model/customer.dart';
import 'package:savdox/src/core/repositories/customer_repository.dart';
import 'package:savdox/src/core/providers/others_providers.dart';

final customerRepositoryProvider = Provider((ref) => CustomerRepository());

class CustomerFormScreen extends HookConsumerWidget {
  final Customer? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final fullnameController = useTextEditingController(
      text: customer?.fullname ?? '',
    );
    final phoneController = useTextEditingController(
      text: customer?.phone ?? '',
    );
    final emailController = useTextEditingController(
      text: customer?.email ?? '',
    );
    final addressController = useTextEditingController(
      text: customer?.address ?? '',
    );

    final isLoading = useState(false);

    Future<void> saveCustomer() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      try {
        final repo = ref.read(customerRepositoryProvider);
        final newCustomer = customer ?? Customer();

        newCustomer.fullname = fullnameController.text;
        newCustomer.phone = phoneController.text.isEmpty
            ? null
            : phoneController.text;
        newCustomer.email = emailController.text.isEmpty
            ? null
            : emailController.text;
        newCustomer.address = addressController.text.isEmpty
            ? null
            : addressController.text;
        newCustomer.status = Customer.activeStatus;
        newCustomer.created = customer?.created ?? DateTime.now();
        newCustomer.updated = DateTime.now();

        if (customer == null) {
          await repo.createCustomer(newCustomer);
        } else {
          await repo.updateCustomer(newCustomer);
        }

        // Refresh customers list
        ref.read(customersProvider.notifier).refresh();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                customer == null
                    ? 'Customer created successfully'
                    : 'Customer updated successfully',
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
        title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: fullnameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              enabled: !isLoading.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
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
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
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
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isLoading.value ? null : saveCustomer,
              icon: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(customer == null ? 'Create' : 'Update'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }
}
