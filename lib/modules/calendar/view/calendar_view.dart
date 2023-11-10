import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../const/app_color.dart';
import '../../../data/model/attendance_model.dart';
import '../../home/view_model/home_view_model.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  Color getColorForStatus(String? status, bool isDateInAttendance) {
    return isDateInAttendance
        ? status == 'Present'
            ? Colors.green
            : Colors.red
        : AppColor.backGroundColor;
  }

  (bool, AttendanceModel?) attendanceInfo(
      DateTime currentDate, attendanceList) {
    bool isDateInAttendance = attendanceList.any((e) =>
        e.date.year == currentDate.year &&
        e.date.month == currentDate.month &&
        e.date.day == currentDate.day);

    AttendanceModel? attendanceItem;
    if (isDateInAttendance) {
      attendanceItem = attendanceList.firstWhere((e) =>
          e.date.year == currentDate.year &&
          e.date.month == currentDate.month &&
          e.date.day == currentDate.day);
    }
    return (isDateInAttendance, attendanceItem);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceList = ref.read(homeViewModelProvider).attendanceItems;

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(color: AppColor.mainColor),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.mainColor),
        backgroundColor: AppColor.backGroundColor,
      ),
      body: SafeArea(
        child: TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime(2023, 11, 1),
          lastDay: DateTime(2024, 12, 31),
          headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle:
                  TextStyle(color: AppColor.mainColor, fontSize: 20.sp),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: AppColor.mainColor,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: AppColor.mainColor,
              )),
          calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(color: AppColor.mainColor),
              markerDecoration: BoxDecoration(
                color: Colors.red,
              )),
          calendarBuilders: CalendarBuilders(
            prioritizedBuilder: (context, date, focusedDay) {
              final currentDate = DateTime(date.year, date.month, date.day);

              final (isDateInAttendance, attendanceItem) =
                  attendanceInfo(currentDate, attendanceList);
              return dateWidget(date, isDateInAttendance, attendanceItem);
            },
          ),
        ),
      ),
    );
  }

  Widget dateWidget(
      DateTime date, bool isDateInAttendance, AttendanceModel? attendanceItem) {
    return Container(
      height: 36,
      width: 36,
      key: ValueKey(date),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColorForStatus(attendanceItem?.status, isDateInAttendance),
      ),
      child: Text(
        '${date.day}',
        style: TextStyle(
            color: AppColor.mainColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
