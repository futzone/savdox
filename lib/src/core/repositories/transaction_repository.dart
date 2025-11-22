import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/transaction_model/transaction.dart';

class TransactionRepository {
  Future<List<Transaction>> getTransactions({
    required int offset,
    required int limit,
    String? searchQuery,
    String? status,
  }) async {
    final isar = IsarDatabase.instance.isar;
    // Use a dummy filter to ensure query is of type QueryBuilder<..., QAfterFilterCondition>
    var query = isar.transactions.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.group(
        (q) => q
            .titleContains(searchQuery, caseSensitive: false)
            .or()
            .noteContains(searchQuery, caseSensitive: false),
      );
    }

    if (status != null) {
      query = query.statusEqualTo(status);
    }

    return await query.offset(offset).limit(limit).findAll();
  }

  Future<int> getTransactionsCount({
    String? searchQuery,
    String? status,
  }) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.transactions.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.group(
        (q) => q
            .titleContains(searchQuery, caseSensitive: false)
            .or()
            .noteContains(searchQuery, caseSensitive: false),
      );
    }

    if (status != null) {
      query = query.statusEqualTo(status);
    }

    return await query.count();
  }

  Future<void> createTransaction(Transaction transaction) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  Future<void> deleteTransaction(int id) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.transactions.delete(id);
    });
  }
}
