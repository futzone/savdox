import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/shopping_model/shopping.dart';

class ShoppingRepository {
  Future<List<Shopping>> getShoppingList({
    required int offset,
    required int limit,
    String? searchQuery,
    String? status,
  }) async {
    final isar = IsarDatabase.instance.isar;
    // Use a dummy filter to ensure query is of type QueryBuilder<..., QAfterFilterCondition>
    var query = isar.shoppings.where().filter().idGreaterThan(-1);

    // Note: Shopping model might not have a title/name field directly searchable like Transaction.
    // Assuming we might search by note or supplierId (if we had supplier name joined, but Isar is NoSQL).
    // For now, searching by note if available.

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.noteContains(searchQuery, caseSensitive: false);
    }

    if (status != null) {
      query = query.statusEqualTo(status);
    }

    return await query.offset(offset).limit(limit).findAll();
  }

  Future<int> getShoppingCount({String? searchQuery, String? status}) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.shoppings.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.noteContains(searchQuery, caseSensitive: false);
    }

    if (status != null) {
      query = query.statusEqualTo(status);
    }

    return await query.count();
  }

  Future<void> createShopping(Shopping shopping) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.shoppings.put(shopping);
    });
  }

  Future<void> updateShopping(Shopping shopping) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.shoppings.put(shopping);
    });
  }

  Future<void> deleteShopping(int id) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.shoppings.delete(id);
    });
  }
}
