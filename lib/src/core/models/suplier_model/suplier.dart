import 'package:isar/isar.dart';

part 'suplier.g.dart';

@collection
class Suplier {
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
  String? description;
  String? imagePath;
  String? address;
}
