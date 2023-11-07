import 'package:attendance_app/data/model/attendance_model.dart';
import 'package:attendance_app/services/local/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  final List<AttendanceModel> attendanceItems;
  final AttendanceModel? currentAttendance;
  HomeViewState({required this.attendanceItems, this.currentAttendance});

  HomeViewState copyWith(
      {List<AttendanceModel>? attendanceItems,
      AttendanceModel? currentAttendance}) {
    return HomeViewState(
      attendanceItems: attendanceItems ?? this.attendanceItems,
      currentAttendance: currentAttendance ?? this.currentAttendance,
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
    final bool isAlreadyAdded = state.attendanceItems.any((element) =>
        element.date.year == currentDate.year &&
        element.date.month == currentDate.month &&
        element.date.day == currentDate.day);
    if (!isAlreadyAdded) {
      final todayAttendance = AttendanceModel()
        ..date = currentDate
        ..status = 'Absent';
      await db.insertAttendance(todayAttendance);
      final updatedList = [...state.attendanceItems, todayAttendance];

      state = state.copyWith(
          attendanceItems: updatedList, currentAttendance: todayAttendance);
    } else {
      final attendanceItem = state.attendanceItems
          .where((element) =>
              element.date.year == currentDate.year &&
              element.date.month == currentDate.month &&
              element.date.day == currentDate.day)
          .first;
      if (attendanceItem.status != 'Present') {
        state = state.copyWith(currentAttendance: attendanceItem);
      }
    }
  }

  void updateAttendanceStatus(String status, DateTime time, DateTime date) {
    final indexOfCurrentItem = state.attendanceItems.indexWhere((element) =>
        element.date.year == date.year &&
        element.date.month == date.month &&
        element.date.day == date.day);
    AttendanceModel attendanceItem = state.attendanceItems[indexOfCurrentItem];
    attendanceItem
      ..status = status
      ..time = time;
    final attendanceItems = state.attendanceItems;
    attendanceItems[indexOfCurrentItem] = attendanceItem;
    state = state.copyWith(attendanceItems: attendanceItems);
  }

  Future<void> fetchAttendanceItems() async {
    final items = await db.fetchAttendanceItems();
    state = state.copyWith(attendanceItems: items.reversed.toList());
  }
}
