import 'package:isar/isar.dart';

part 'employee.g.dart';

@collection
class Employee {
  static const String activeStatus = 'active';
  static const String deletedStatus = 'deleted';
  static const String archivedStatus = 'archived';

  Id id = Isar.autoIncrement;
  late String fullname;
  late String pin;
  late DateTime created;
  late DateTime updated;
  late String status;

  DateTime? deleted;
  String? phone;
  double? salary;
  String? description;
  String? imagePath;
  String? role;
  List<String> permissions = [];
  String? color;
}
