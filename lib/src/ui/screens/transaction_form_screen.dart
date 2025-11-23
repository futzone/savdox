import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/transaction_model/transaction.dart';
import 'package:savdox/src/core/repositories/transaction_repository.dart';
import 'package:savdox/src/core/models/customer_model/customer.dart';
import 'package:savdox/src/core/models/employee_model/employee.dart';
import 'package:savdox/src/ui/widgets/customer_selection_sheet.dart';
import 'package:savdox/src/ui/widgets/employee_selection_sheet.dart';

final transactionRepositoryProvider = Provider(
  (ref) => TransactionRepository(),
);

class TransactionFormScreen extends HookConsumerWidget {
  final Transaction? transaction;

  const TransactionFormScreen({super.key, this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Form Controllers
    final titleController = useTextEditingController(
      text: transaction?.title ?? '',
    );
    final amountController = useTextEditingController(
      text: transaction?.totalSum.toStringAsFixed(2) ?? '',
    );
    final noteController = useTextEditingController(
      text: transaction?.note ?? '',
    );

    // State
    final isCashOut = useState(transaction?.cashOut ?? false);
    final selectedCustomer = useState<Customer?>(null);
    final selectedEmployee = useState<Employee?>(null);
    final isLoading = useState(false);

    Future<void> saveTransaction() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      try {
        final repo = ref.read(transactionRepositoryProvider);
        final newTransaction = transaction ?? Transaction();

        newTransaction.title = titleController.text;
        newTransaction.totalSum = double.parse(amountController.text);
        newTransaction.cashOut = isCashOut.value;
        newTransaction.customerId = selectedCustomer.value?.id;
        newTransaction.employeeId = selectedEmployee.value?.id;
        newTransaction.note = noteController.text;
        newTransaction.status = Transaction.activeStatus;
        newTransaction.created = transaction?.created ?? DateTime.now();
        newTransaction.updated = DateTime.now();

        if (transaction == null) {
          await repo.createTransaction(newTransaction);
        } else {
          await repo.updateTransaction(newTransaction);
        }

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                transaction == null
                    ? 'Transaction created successfully'
                    : 'Transaction updated successfully',
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

    Future<void> selectCustomer() async {
      final Customer? customer = await showModalBottomSheet<Customer>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const CustomerSelectionSheet(),
      );

      if (customer != null) {
        selectedCustomer.value = customer;
      }
    }

    Future<void> selectEmployee() async {
      final Employee? employee = await showModalBottomSheet<Employee>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const EmployeeSelectionSheet(),
      );

      if (employee != null) {
        selectedEmployee.value = employee;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              enabled: !isLoading.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Cash In/Out Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz),
                    const SizedBox(width: 16),
                    const Text('Transaction Type:'),
                    const Spacer(),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Cash In'),
                          icon: Icon(Icons.arrow_downward, color: Colors.green),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('Cash Out'),
                          icon: Icon(Icons.arrow_upward, color: Colors.red),
                        ),
                      ],
                      selected: {isCashOut.value},
                      onSelectionChanged: (Set<bool> selected) {
                        isCashOut.value = selected.first;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                suffix: Text(
                  isCashOut.value ? '(Out)' : '(In)',
                  style: TextStyle(
                    color: isCashOut.value ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: !isLoading.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Customer Selection
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Customer'),
                subtitle: Text(
                  selectedCustomer.value?.fullname ?? 'Not selected',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: isLoading.value ? null : selectCustomer,
              ),
            ),
            const SizedBox(height: 16),

            // Employee Selection
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('Employee'),
                subtitle: Text(
                  selectedEmployee.value?.fullname ?? 'Not selected',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: isLoading.value ? null : selectEmployee,
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
              maxLines: 3,
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 24),

            // Save Button
            FilledButton.icon(
              onPressed: isLoading.value ? null : saveTransaction,
              icon: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(transaction == null ? 'Create' : 'Update'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }
}
