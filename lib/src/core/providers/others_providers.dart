import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/customer_model/customer.dart';
import 'package:savdox/src/core/models/employee_model/employee.dart';
import 'package:savdox/src/core/models/suplier_model/suplier.dart';
import 'package:savdox/src/core/repositories/customer_repository.dart';
import 'package:savdox/src/core/repositories/employee_repository.dart';
import 'package:savdox/src/core/repositories/suplier_repository.dart';

// --- Repositories ---

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepository();
});

final suplierRepositoryProvider = Provider<SuplierRepository>((ref) {
  return SuplierRepository();
});

// --- Customers State ---

final customerSearchQueryProvider = StateProvider<String>((ref) => '');

class CustomersNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final CustomerRepository _repository;
  final Ref _ref;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  CustomersNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    if (!_hasMore && _currentPage > 0) return;
    state = const AsyncValue.loading();
    try {
      final searchQuery = _ref.read(customerSearchQueryProvider);
      final items = await _repository.getCustomers(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
      if (items.length < _pageSize) _hasMore = false;
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final currentItems = state.value ?? [];
    try {
      final searchQuery = _ref.read(customerSearchQueryProvider);
      _currentPage++;
      final newItems = await _repository.getCustomers(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
      if (newItems.length < _pageSize) _hasMore = false;
      state = AsyncValue.data([...currentItems, ...newItems]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _currentPage = 0;
    _hasMore = true;
    loadCustomers();
  }

  bool get hasMore => _hasMore;
}

final customersProvider =
    StateNotifierProvider<CustomersNotifier, AsyncValue<List<Customer>>>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return CustomersNotifier(repository, ref);
    });

// --- Employees State ---

final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

class EmployeesNotifier extends StateNotifier<AsyncValue<List<Employee>>> {
  final EmployeeRepository _repository;
  final Ref _ref;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  EmployeesNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    if (!_hasMore && _currentPage > 0) return;
    state = const AsyncValue.loading();
    try {
      final searchQuery = _ref.read(employeeSearchQueryProvider);
      final items = await _repository.getEmployees(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
      if (items.length < _pageSize) _hasMore = false;
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final currentItems = state.value ?? [];
    try {
      final searchQuery = _ref.read(employeeSearchQueryProvider);
      _currentPage++;
      final newItems = await _repository.getEmployees(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
      if (newItems.length < _pageSize) _hasMore = false;
      state = AsyncValue.data([...currentItems, ...newItems]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _currentPage = 0;
    _hasMore = true;
    loadEmployees();
  }

  bool get hasMore => _hasMore;
}

final employeesProvider =
    StateNotifierProvider<EmployeesNotifier, AsyncValue<List<Employee>>>((ref) {
      final repository = ref.watch(employeeRepositoryProvider);
      return EmployeesNotifier(repository, ref);
    });

// --- Suppliers State ---

final suplierSearchQueryProvider = StateProvider<String>((ref) => '');

class SupliersNotifier extends StateNotifier<AsyncValue<List<Suplier>>> {
  final SuplierRepository _repository;
  final Ref _ref;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  SupliersNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadSupliers();
  }

  Future<void> loadSupliers() async {
    if (!_hasMore && _currentPage > 0) return;
    state = const AsyncValue.loading();
    try {
      final searchQuery = _ref.read(suplierSearchQueryProvider);
      final items = await _repository.getSupliers(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
      if (items.length < _pageSize) _hasMore = false;
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final currentItems = state.value ?? [];
    try {
      final searchQuery = _ref.read(suplierSearchQueryProvider);
      _currentPage++;
      final newItems = await _repository.getSupliers(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
      if (newItems.length < _pageSize) _hasMore = false;
      state = AsyncValue.data([...currentItems, ...newItems]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _currentPage = 0;
    _hasMore = true;
    loadSupliers();
  }

  bool get hasMore => _hasMore;
}

final supliersProvider =
    StateNotifierProvider<SupliersNotifier, AsyncValue<List<Suplier>>>((ref) {
      final repository = ref.watch(suplierRepositoryProvider);
      return SupliersNotifier(repository, ref);
    });
