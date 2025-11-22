import 'package:isar/isar.dart';
part 'product.g.dart';

@collection
class Product {
  static const String activeStatus = 'active';
  static const String deletedStatus = 'deleted';
  static const String archivedStatus = 'archived';

  Id id = Isar.autoIncrement;
  late String name;
  late double price;
  late DateTime created;
  late DateTime updated;
  late String status;


  DateTime? deleted;
  String? unit;
  double? unitPrice;
  String? description;
  String? imagePath;
  String? barcode;
  String? category;
  String? tags;
  int? index;
  String? color;
  String? size;
  double? amount;
}
