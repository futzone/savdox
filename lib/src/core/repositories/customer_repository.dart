import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/customer_model/customer.dart';

class CustomerRepository {
  Future<List<Customer>> getCustomers({
    required int offset,
    required int limit,
    String? searchQuery,
  }) async {
    final isar = IsarDatabase.instance.isar;
    // Use a dummy filter to ensure query is of type QueryBuilder<..., QAfterFilterCondition>
    var query = isar.customers.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.and().group(
        (q) => q
            .fullnameContains(searchQuery, caseSensitive: false)
            .or()
            .phoneContains(searchQuery, caseSensitive: false)
            .or()
            .emailContains(searchQuery, caseSensitive: false),
      );
    }

    query = query.statusEqualTo(Customer.activeStatus);

    return await query.offset(offset).limit(limit).findAll();
  }

  Future<int> getCustomersCount({String? searchQuery}) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.customers.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.and().group(
        (q) => q
            .fullnameContains(searchQuery, caseSensitive: false)
            .or()
            .phoneContains(searchQuery, caseSensitive: false)
            .or()
            .emailContains(searchQuery, caseSensitive: false),
      );
    }

    query = query.statusEqualTo(Customer.activeStatus);

    return await query.count();
  }

  Future<void> createCustomer(Customer customer) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.customers.put(customer);
    });
  }

  Future<void> updateCustomer(Customer customer) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.customers.put(customer);
    });
  }

  Future<void> deleteCustomer(int id) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      final customer = await isar.customers.get(id);
      if (customer != null) {
        customer.status = Customer.deletedStatus;
        await isar.customers.put(customer);
      }
    });
  }
}
