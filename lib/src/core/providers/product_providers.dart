import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/product_model/product.dart';
import 'package:savdox/src/core/repositories/product_repository.dart';

// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Search query state
final productSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter state
class ProductFilters {
  final String? category;
  final String? status;

  ProductFilters({this.category, this.status});

  ProductFilters copyWith({String? category, String? status}) {
    return ProductFilters(
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  bool get hasFilters => category != null || status != null;

  void clear() {}
}

final productFiltersProvider = StateProvider<ProductFilters>((ref) {
  return ProductFilters();
});

// Categories provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getCategories();
});

// Products list with pagination
class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository _repository;
  final Ref _ref;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  ProductsNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    if (!_hasMore && _currentPage > 0) return;

    state = const AsyncValue.loading();

    try {
      final searchQuery = _ref.read(productSearchQueryProvider);
      final filters = _ref.read(productFiltersProvider);

      final products = await _repository.getProducts(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
        category: filters.category,
        status: filters.status,
      );

      if (products.length < _pageSize) {
        _hasMore = false;
      }

      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    final currentProducts = state.value ?? [];

    try {
      final searchQuery = _ref.read(productSearchQueryProvider);
      final filters = _ref.read(productFiltersProvider);

      _currentPage++;
      final newProducts = await _repository.getProducts(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
        category: filters.category,
        status: filters.status,
      );

      if (newProducts.length < _pageSize) {
        _hasMore = false;
      }

      state = AsyncValue.data([...currentProducts, ...newProducts]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _currentPage = 0;
    _hasMore = true;
    loadProducts();
  }

  bool get hasMore => _hasMore;
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
      final repository = ref.watch(productRepositoryProvider);
      return ProductsNotifier(repository, ref);
    });

// Product count provider
final productCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final searchQuery = ref.watch(productSearchQueryProvider);
  final filters = ref.watch(productFiltersProvider);

  return await repository.getProductsCount(
    searchQuery: searchQuery.isEmpty ? null : searchQuery,
    category: filters.category,
    status: filters.status,
  );
});

// Selected product for editing
final selectedProductProvider = StateProvider<Product?>((ref) => null);

// Provider for searching products in the selection sheet
final productSelectionProvider = FutureProvider.family
    .autoDispose<List<Product>, String>((ref, query) async {
      final repository = ref.watch(productRepositoryProvider);
      return await repository.getProducts(
        searchQuery: query.isEmpty ? null : query,
        limit: 50, // Limit results for selection
      );
    });
