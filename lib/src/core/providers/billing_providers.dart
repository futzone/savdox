import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/shopping_model/shopping.dart';
import 'package:savdox/src/core/models/transaction_model/transaction.dart';
import 'package:savdox/src/core/repositories/shopping_repository.dart';
import 'package:savdox/src/core/repositories/transaction_repository.dart';

// Repositories
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepository();
});

// --- Transactions State ---

final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

class TransactionFilters {
  final String? status;
  TransactionFilters({this.status});
}

final transactionFiltersProvider = StateProvider<TransactionFilters>((ref) {
  return TransactionFilters();
});

class TransactionsNotifier
    extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionRepository _repository;
  final Ref _ref;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  TransactionsNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    if (!_hasMore && _currentPage > 0) return;
    state = const AsyncValue.loading();
    try {
      final searchQuery = _ref.read(transactionSearchQueryProvider);
      final filters = _ref.read(transactionFiltersProvider);
      final items = await _repository.getTransactions(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
        status: filters.status,
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
      final searchQuery = _ref.read(transactionSearchQueryProvider);
      final filters = _ref.read(transactionFiltersProvider);
      _currentPage++;
      final newItems = await _repository.getTransactions(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
        status: filters.status,
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
    loadTransactions();
  }

  bool get hasMore => _hasMore;
}

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, AsyncValue<List<Transaction>>>((
      ref,
    ) {
      final repository = ref.watch(transactionRepositoryProvider);
      return TransactionsNotifier(repository, ref);
    });

// --- Shopping State ---

final shoppingSearchQueryProvider = StateProvider<String>((ref) => '');

class ShoppingFilters {
  final String? status;
  ShoppingFilters({this.status});
}

final shoppingFiltersProvider = StateProvider<ShoppingFilters>((ref) {
  return ShoppingFilters();
});

class ShoppingNotifier extends StateNotifier<AsyncValue<List<Shopping>>> {
  final ShoppingRepository _repository;
  final Ref _ref;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  ShoppingNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadShoppingList();
  }

  Future<void> loadShoppingList() async {
    if (!_hasMore && _currentPage > 0) return;
    state = const AsyncValue.loading();
    try {
      final searchQuery = _ref.read(shoppingSearchQueryProvider);
      final filters = _ref.read(shoppingFiltersProvider);
      final items = await _repository.getShoppingList(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
        status: filters.status,
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
      final searchQuery = _ref.read(shoppingSearchQueryProvider);
      final filters = _ref.read(shoppingFiltersProvider);
      _currentPage++;
      final newItems = await _repository.getShoppingList(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
        status: filters.status,
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
    loadShoppingList();
  }

  bool get hasMore => _hasMore;
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingNotifier, AsyncValue<List<Shopping>>>((ref) {
      final repository = ref.watch(shoppingRepositoryProvider);
      return ShoppingNotifier(repository, ref);
    });
