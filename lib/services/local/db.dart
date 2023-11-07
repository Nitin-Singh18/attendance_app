import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/model/attendance_model.dart';

class IsarDatabase {
  static late Isar _isar;

  static Future<void> openDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [AttendanceModelSchema],
      directory: dir.path,
    );
  }

  Future<void> insertAttendance(AttendanceModel item) async {
    await _isar.writeTxn(() async => await _isar.attendanceModels.put(item));
  }

  Future<List<AttendanceModel>> fetchAttendanceItems() async {
    return await _isar.attendanceModels.where().findAll();
  }

  Future<void> updateAttendance(String presentStatus, DateTime attendanceTime,
      AttendanceModel currentAttendance) async {
    final attendanceItem = await _isar.attendanceModels
        .filter()
        .dateEqualTo(currentAttendance.date)
        .findFirst();
    if (attendanceItem != null) {
      attendanceItem.status = presentStatus;
      attendanceItem.time = attendanceTime;
      await _isar.writeTxn(
          () async => await _isar.attendanceModels.put(attendanceItem));
    }
  }
}
