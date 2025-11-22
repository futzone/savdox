import 'package:isar/isar.dart';

import '../payment_type_model/payment_type.dart';

part 'order.g.dart';

@collection
class Order {
  static const String activeStatus = 'active';
  static const String deletedStatus = 'deleted';
  static const String archivedStatus = 'archived';

  Id id = Isar.autoIncrement;
  late DateTime created;
  late DateTime updated;
  late String status;
  late double totalSum;
  late double finalSum;
  List<OrderItem> items = [];
  List<PaymentType> payments = [];

  DateTime? deleted;
  double? discountSum;
  String? discountReason;
  int? customerId;
  int? employeeId;
  String? note;
}

@embedded
class OrderItem {
  late int productId;
  late String name;
  late double price;
  late double unitPrice;
  late double amount;
  double? customPrice;
}
