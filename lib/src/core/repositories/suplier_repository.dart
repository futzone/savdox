import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/suplier_model/suplier.dart';

class SuplierRepository {
  Future<List<Suplier>> getSupliers({
    required int offset,
    required int limit,
    String? searchQuery,
  }) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.supliers.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.and().group(
        (q) => q
            .fullnameContains(searchQuery, caseSensitive: false)
            .or()
            .phoneContains(searchQuery, caseSensitive: false),
      );
    }

    query = query.statusEqualTo(Suplier.activeStatus);

    return await query.offset(offset).limit(limit).findAll();
  }

  Future<int> getSupliersCount({String? searchQuery}) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.supliers.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.and().group(
        (q) => q
            .fullnameContains(searchQuery, caseSensitive: false)
            .or()
            .phoneContains(searchQuery, caseSensitive: false),
      );
    }

    query = query.statusEqualTo(Suplier.activeStatus);

    return await query.count();
  }

  Future<void> createSuplier(Suplier suplier) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.supliers.put(suplier);
    });
  }

  Future<void> updateSuplier(Suplier suplier) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.supliers.put(suplier);
    });
  }

  Future<void> deleteSuplier(int id) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      final suplier = await isar.supliers.get(id);
      if (suplier != null) {
        suplier.status = Suplier.deletedStatus;
        await isar.supliers.put(suplier);
      }
    });
  }
}
