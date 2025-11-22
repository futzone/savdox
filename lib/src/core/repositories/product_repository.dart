import 'package:faker/faker.dart';
import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/product_model/product.dart';

class ProductRepository {
  final Isar _isar = IsarDatabase.instance.isar;

  /// Fetch products with pagination and optional search/filter
  Future<List<Product>> getProducts({
    int offset = 0,
    int limit = 20,
    String? searchQuery,
    String? category,
    String? status,
  }) async {
    // Build query with all filters in a single chain
    var query = _isar.products.where().filter().statusEqualTo(
      status ?? Product.activeStatus,
    );

    // Apply category filter
    if (category != null && category.isNotEmpty) {
      query = query.categoryEqualTo(category);
    }

    // Apply search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
          .nameContains(searchQuery, caseSensitive: false)
          .or()
          .barcodeContains(searchQuery, caseSensitive: false);
    }

    return await query.sortByNameDesc().offset(offset).limit(limit).findAll();
  }

  /// Get total count of products
  Future<int> getProductsCount({
    String? searchQuery,
    String? category,
    String? status,
  }) async {
    // Build query with all filters in a single chain
    var query = _isar.products.where().filter().statusEqualTo(
      status ?? Product.activeStatus,
    );

    if (category != null && category.isNotEmpty) {
      query = query.categoryEqualTo(category);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
          .nameContains(searchQuery, caseSensitive: false)
          .or()
          .barcodeContains(searchQuery, caseSensitive: false);
    }

    return await query.count();
  }

  /// Get all unique categories
  Future<List<String>> getCategories() async {
    final products = await _isar.products
        .where()
        .filter()
        .statusEqualTo(Product.activeStatus)
        .categoryIsNotNull()
        .findAll();

    final categories = products
        .map((p) => p.category!)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    return categories;
  }

  /// Get product by ID
  Future<Product?> getProductById(int id) async {
    return await _isar.products.get(id);
  }

  /// Create a new product
  Future<int> createProduct(Product product) async {
    product.created = DateTime.now();
    product.updated = DateTime.now();
    product.status = Product.activeStatus;


    // for (int i = 0; i <= 3000; i++) {
    //   final faker = Faker();
    //   Product product = Product()
    //     ..price = faker.randomGenerator.integer(1000000, min: 1000).toDouble()
    //     ..name = faker.food.restaurant()
    //     ..created = DateTime.now()
    //     ..updated = DateTime.now()
    //     ..status = Product.activeStatus
    //     ..amount = faker.randomGenerator.integer(1000, min: 10).toDouble();
    //
    //   await _isar.writeTxn(() async {
    //     return await _isar.products.put(product);
    //   });
    // }

    return await _isar.writeTxn(() async {
      return await _isar.products.put(product);
    });
  }

  /// Update an existing product
  Future<void> updateProduct(Product product) async {
    product.updated = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.products.put(product);
    });
  }

  /// Delete a product (soft delete by changing status)
  Future<void> deleteProduct(int id) async {
    final product = await getProductById(id);
    if (product != null) {
      product.status = Product.deletedStatus;
      product.deleted = DateTime.now();
      await updateProduct(product);
    }
  }

  /// Search products by name or barcode
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    return await _isar.products
        .where()
        .filter()
        .statusEqualTo(Product.activeStatus)
        .and()
        .group(
          (q) => q
              .nameContains(query, caseSensitive: false)
              .or()
              .barcodeContains(query, caseSensitive: false),
        )
        .limit(50)
        .findAll();
  }
}
