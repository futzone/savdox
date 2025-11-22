import 'package:isar/isar.dart';
import 'package:savdox/src/core/models/customer_model/customer.dart';
import 'package:savdox/src/core/models/employee_model/employee.dart';
import 'package:savdox/src/core/models/order_model/order.dart';
import 'package:savdox/src/core/models/product_model/product.dart';
import 'package:savdox/src/core/models/shopping_model/shopping.dart';
import 'package:savdox/src/core/models/suplier_model/suplier.dart';
import 'package:savdox/src/core/models/transaction_model/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

Future<void> initDatabase() async {
  if (Platform.isWindows) {
    final appDir = await getApplicationSupportDirectory();
    final isarDir = Directory(path.join(appDir.path));
    await IsarDatabase.instance.init(isarDir.path);
  } else {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(path.join(appDir.path));
    await IsarDatabase.instance.init(dir.path);
  }
}

class IsarDatabase {
  static final IsarDatabase instance = IsarDatabase._internal();

  factory IsarDatabase() => instance;

  IsarDatabase._internal();

  late Isar isar;

  Future<Isar> init(String dir) async {
    isar = await Isar.open(
      [
        OrderSchema,
        CustomerSchema,
        EmployeeSchema,
        ProductSchema,
        ShoppingSchema,
        SuplierSchema,
        TransactionSchema,
      ],
      inspector: true,
      directory: dir,
    );

    return isar;
  }
}
