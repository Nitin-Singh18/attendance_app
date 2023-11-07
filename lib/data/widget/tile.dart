import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../const/app_color.dart';
import '../model/attendance_model.dart';

class AttendanceTile extends StatelessWidget {
  final AttendanceModel attendanceItem;
  const AttendanceTile({required this.attendanceItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 340.w,
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColor.mainColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('d MMM, EEE').format(attendanceItem.date),
                style: TextStyle(color: AppColor.mainColor, fontSize: 22.sp),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: AppColor.mainColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    attendanceItem.time == null
                        ? 'Not Scanned'
                        : DateFormat('hh:mm a').format(attendanceItem.time!),
                    style:
                        TextStyle(color: AppColor.mainColor, fontSize: 14.sp),
                  ),
                ],
              )
            ],
          ),
          Text(
            attendanceItem.status,
            style: TextStyle(color: AppColor.mainColor, fontSize: 26.sp),
          ),
        ],
      ),
    );
  }
}
