import 'package:isar/isar.dart';

import '../payment_type_model/payment_type.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  static const String activeStatus = 'active';
  static const String deletedStatus = 'deleted';
  static const String archivedStatus = 'archived';

  Id id = Isar.autoIncrement;
  late String title;
  late DateTime created;
  late DateTime updated;
  late String status;
  late bool cashOut;
  late double totalSum;
  List<PaymentType> payments = [];

  int? customerId;
  DateTime? deleted;
  int? employeeId;
  int? suplierId;
  int? orderId;
  int? shoppingId;
  String? note;
}
