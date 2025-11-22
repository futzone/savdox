import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/providers/others_providers.dart';

class EmployeesScreen extends HookConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final employeesAsync = ref.watch(employeesProvider);
    final theme = Theme.of(context);

    // Debounce search
    useEffect(() {
      void listener() {
        ref.read(employeeSearchQueryProvider.notifier).state =
            searchController.text;
        ref.read(employeesProvider.notifier).refresh();
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add employee functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Employee coming soon')),
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
                hintText: 'Search employees...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: employeesAsync.when(
              data: (employees) {
                if (employees.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No employees found',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: employees.length + 1,
                  itemBuilder: (context, index) {
                    if (index == employees.length) {
                      if (ref.read(employeesProvider.notifier).hasMore) {
                        ref.read(employeesProvider.notifier).loadMore();
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox(height: 20);
                    }
                    final employee = employees[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          employee.fullname.isNotEmpty
                              ? employee.fullname[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(employee.fullname),
                      subtitle: Text(employee.role ?? 'No Role'),
                      onTap: () {
                        // TODO: Show employee details/edit
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
