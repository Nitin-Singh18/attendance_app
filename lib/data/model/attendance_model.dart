import 'package:isar/isar.dart';

part 'attendance_model.g.dart';

@collection
class AttendanceModel {
  Id id = Isar.autoIncrement;
  late DateTime date;
  DateTime? time;
  late String status;
}
