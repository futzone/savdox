import 'package:isar/isar.dart';

import '../payment_type_model/payment_type.dart';

part 'shopping.g.dart';

@collection
class Shopping {
  static const String activeStatus = 'active';
  static const String deletedStatus = 'deleted';
  static const String archivedStatus = 'archived';

  Id id = Isar.autoIncrement;
  late DateTime created;
  late DateTime updated;
  late String status;
  late double totalSum;
  late double finalSum;
  late int supplierId;
  List<ShoppingItem> items = [];
  List<PaymentType> payments = [];

  DateTime? deleted;
  double? discountSum;
  String? discountReason;
  String? note;
}

@embedded
class ShoppingItem {
  late int productId;
  late String name;
  late double price;
  late double unitPrice;
  late double amount;
  double? customPrice;
}
