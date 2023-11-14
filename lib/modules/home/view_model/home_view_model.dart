import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/attendance_model.dart';
import '../../../services/local/isar_db.dart';

class HomeViewState {
  final List<AttendanceModel> attendanceItems;
  final AttendanceModel? currentAttendance;
  HomeViewState({required this.attendanceItems, this.currentAttendance});

  HomeViewState copyWith(
      {List<AttendanceModel>? attendanceItems,
      AttendanceModel? currentAttendance}) {
    return HomeViewState(
      attendanceItems: attendanceItems ?? this.attendanceItems,
      currentAttendance: currentAttendance,
    );
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeViewState>(
        (ref) => HomeViewModel());

class HomeViewModel extends StateNotifier<HomeViewState> {
  HomeViewModel() : super(HomeViewState(attendanceItems: []));

  IsarDatabase db = IsarDatabase();

  Future<void> createTodayAttendance() async {
    await fetchAttendanceItems();
    final DateTime currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final bool isMissing = _checkForMissedDates(currentDate);
    if (!isMissing) {
      final bool isAlreadyAdded =
          _isAttendanceItemAlreadyAdded(state.attendanceItems, currentDate);
      if (!isAlreadyAdded) {
        final todayAttendance = AttendanceModel()
          ..date = currentDate
          ..status = 'Absent';
        await db.insertAttendance(todayAttendance);

        state = state.copyWith(
            attendanceItems: [todayAttendance, ...state.attendanceItems],
            currentAttendance: todayAttendance);
      } else {
        _addCurrentAttendance(currentDate);
      }
    } else {
      _addCurrentAttendance(currentDate);
    }
  }

  void _addCurrentAttendance(DateTime currentDate) {
    final attendanceItem =
        _getAttendanceItemByDate(state.attendanceItems, currentDate);
    if (attendanceItem.status != 'Present') {
      state = state.copyWith(currentAttendance: attendanceItem);
    }
  }

  bool _checkForMissedDates(DateTime currentDate) {
    DateTime? lastRecordedDate;
    int? differenceInDays;
    if (state.attendanceItems.isNotEmpty) {
      lastRecordedDate = state.attendanceItems.first.date;

      differenceInDays = currentDate.difference(lastRecordedDate).inDays;

      if (differenceInDays != 1) {
        _addMissingDates(differenceInDays, lastRecordedDate);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _addMissingDates(int differenceInDays, DateTime lastRecordedDate) async {
    final List<DateTime> missingDates = [];
    for (int i = 1; i <= differenceInDays; i++) {
      final DateTime missingDate = lastRecordedDate.add(Duration(days: i));
      missingDates.add(missingDate);
    }

    final List<AttendanceModel> missingAttendanceItems = [];
    for (final DateTime missingDate in missingDates) {
      final missingAttendance = AttendanceModel()
        ..date = missingDate
        ..status = 'Absent';
      await db.insertAttendance(missingAttendance);
      missingAttendanceItems.add(missingAttendance);
    }
    final updatedAttendanceList = [
      ...state.attendanceItems,
      ...missingAttendanceItems
    ];
    updatedAttendanceList.sort((a, b) => b.date.compareTo(a.date));

    state = state.copyWith(attendanceItems: updatedAttendanceList);
  }

  double calculateAttendancePercentage() {
    // Calculate the total number of days and days present
    final totalDays = state.attendanceItems.length;
    final daysPresent =
        state.attendanceItems.where((e) => e.status == 'Present').length;

    // Calculate the percentage
    final attendancePercentage = (daysPresent / totalDays) * 100;

    return attendancePercentage;
  }

  bool _isAttendanceItemAlreadyAdded(
      List<AttendanceModel> attendanceItems, DateTime currentDate) {
    return attendanceItems.any((element) =>
        element.date.year == currentDate.year &&
        element.date.month == currentDate.month &&
        element.date.day == currentDate.day);
  }

  AttendanceModel _getAttendanceItemByDate(
      List<AttendanceModel> attendanceItems, DateTime date) {
    return attendanceItems.firstWhere((element) =>
        element.date.year == date.year &&
        element.date.month == date.month &&
        element.date.day == date.day);
  }

  void updateTodayAttendanceState(String status, DateTime time, DateTime date) {
    final indexOfTodayAttendance = state.attendanceItems.indexWhere((element) =>
        element.date.year == date.year &&
        element.date.month == date.month &&
        element.date.day == date.day);
    AttendanceModel attendanceItem =
        state.attendanceItems[indexOfTodayAttendance]
          ..status = status
          ..time = time;

    final updatedAttendanceItems = state.attendanceItems;
    updatedAttendanceItems[indexOfTodayAttendance] = attendanceItem;
    state = state.copyWith(
        attendanceItems: updatedAttendanceItems, currentAttendance: null);
  }

  Future<void> fetchAttendanceItems() async {
    final items = await db.fetchAttendanceItems();
    items.sort((a, b) => b.date.compareTo(a.date));
    state = state.copyWith(attendanceItems: items);
  }
}
