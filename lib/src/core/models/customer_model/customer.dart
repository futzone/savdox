import 'package:isar/isar.dart';

part 'customer.g.dart';

@collection
class Customer {
  static const String activeStatus = 'active';
  static const String deletedStatus = 'deleted';
  static const String archivedStatus = 'archived';

  Id id = Isar.autoIncrement;
  late String fullname;
  late DateTime created;
  late DateTime updated;
  late String status;

  DateTime? deleted;
  String? phone;
  int? totalOrders;
  double? totalSales;
  String? description;
  String? email;
  String? address;
  String? source;
}
