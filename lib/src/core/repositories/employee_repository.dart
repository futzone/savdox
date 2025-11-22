import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/employee_model/employee.dart';

class EmployeeRepository {
  Future<List<Employee>> getEmployees({
    required int offset,
    required int limit,
    String? searchQuery,
  }) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.employees.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.and().group(
        (q) => q
            .fullnameContains(searchQuery, caseSensitive: false)
            .or()
            .phoneContains(searchQuery, caseSensitive: false),
      );
    }

    query = query.statusEqualTo(Employee.activeStatus);

    return await query.offset(offset).limit(limit).findAll();
  }

  Future<int> getEmployeesCount({String? searchQuery}) async {
    final isar = IsarDatabase.instance.isar;
    var query = isar.employees.where().filter().idGreaterThan(-1);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.and().group(
        (q) => q
            .fullnameContains(searchQuery, caseSensitive: false)
            .or()
            .phoneContains(searchQuery, caseSensitive: false),
      );
    }

    query = query.statusEqualTo(Employee.activeStatus);

    return await query.count();
  }

  Future<void> createEmployee(Employee employee) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.employees.put(employee);
    });
  }

  Future<void> updateEmployee(Employee employee) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      await isar.employees.put(employee);
    });
  }

  Future<void> deleteEmployee(int id) async {
    final isar = IsarDatabase.instance.isar;
    await isar.writeTxn(() async {
      final employee = await isar.employees.get(id);
      if (employee != null) {
        employee.status = Employee.deletedStatus;
        await isar.employees.put(employee);
      }
    });
  }
}
