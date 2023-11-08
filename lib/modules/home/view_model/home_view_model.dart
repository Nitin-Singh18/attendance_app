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
    final bool isAlreadyAdded =
        _isAttendanceItemAlreadyAdded(state.attendanceItems, currentDate);
    if (!isAlreadyAdded) {
      final todayAttendance = AttendanceModel()
        ..date = currentDate
        ..status = 'Absent';
      await db.insertAttendance(todayAttendance);

      state = state.copyWith(
          attendanceItems:
              [...state.attendanceItems, todayAttendance].reversed.toList(),
          currentAttendance: todayAttendance);
    } else {
      final attendanceItem =
          _getAttendanceItemByDate(state.attendanceItems, currentDate);
      if (attendanceItem.status != 'Present') {
        state = state.copyWith(currentAttendance: attendanceItem);
      }
    }
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
    state = state.copyWith(attendanceItems: items.reversed.toList());
  }
}
