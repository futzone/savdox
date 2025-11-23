import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/employee_model/employee.dart';
import 'package:savdox/src/core/repositories/employee_repository.dart';

final employeeSelectionProvider = FutureProvider.family<List<Employee>, String>(
  (ref, searchQuery) async {
    final repo = EmployeeRepository();
    return await repo.getEmployees(
      offset: 0,
      limit: 50,
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
    );
  },
);

class EmployeeSelectionSheet extends HookConsumerWidget {
  const EmployeeSelectionSheet({super.key});

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

    final employeesAsync = ref.watch(
      employeeSelectionProvider(searchQuery.value),
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
                          hintText: 'Search employees...',
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
                child: employeesAsync.when(
                  data: (employees) {
                    if (employees.isEmpty) {
                      return Center(
                        child: Text(
                          'No employees found',
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
                      itemCount: employees.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return ListTile(
                          leading: employee.imagePath != null
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(
                                    employee.imagePath!,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: employee.color != null
                                      ? Color(int.parse(employee.color!))
                                      : theme.colorScheme.primaryContainer,
                                  child: Text(
                                    employee.fullname
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                          title: Text(
                            employee.fullname,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(employee.role ?? 'Employee'),
                          onTap: () {
                            Navigator.pop(context, employee);
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
