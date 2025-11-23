import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/employee_model/employee.dart';
import 'package:savdox/src/core/repositories/employee_repository.dart';
import 'package:savdox/src/core/providers/others_providers.dart';

final employeeRepositoryProvider = Provider((ref) => EmployeeRepository());

class EmployeeFormScreen extends HookConsumerWidget {
  final Employee? employee;

  const EmployeeFormScreen({super.key, this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final fullnameController = useTextEditingController(
      text: employee?.fullname ?? '',
    );
    final pinController = useTextEditingController(text: employee?.pin ?? '');
    final phoneController = useTextEditingController(
      text: employee?.phone ?? '',
    );
    final roleController = useTextEditingController(text: employee?.role ?? '');

    final isLoading = useState(false);

    Future<void> saveEmployee() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      try {
        final repo = ref.read(employeeRepositoryProvider);
        final newEmployee = employee ?? Employee();

        newEmployee.fullname = fullnameController.text;
        newEmployee.pin = pinController.text;
        newEmployee.phone = phoneController.text;
        newEmployee.role = roleController.text.isEmpty
            ? null
            : roleController.text;
        newEmployee.status = Employee.activeStatus;
        newEmployee.created = employee?.created ?? DateTime.now();
        newEmployee.updated = DateTime.now();

        if (employee == null) {
          await repo.createEmployee(newEmployee);
        } else {
          await repo.updateEmployee(newEmployee);
        }

        // Refresh employees list
        ref.read(employeesProvider.notifier).refresh();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                employee == null
                    ? 'Employee created successfully'
                    : 'Employee updated successfully',
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
        title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
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
              controller: pinController,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              keyboardType: TextInputType.number,
              enabled: !isLoading.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter PIN';
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
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                hintText: 'e.g. Manager, Cashier',
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isLoading.value ? null : saveEmployee,
              icon: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(employee == null ? 'Create' : 'Update'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }
}
