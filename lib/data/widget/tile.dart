import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/app_color.dart';

class AttendanceTile extends StatelessWidget {
  const AttendanceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
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
                '3 Nov, Fri',
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
                    '08:01 AM',
                    style:
                        TextStyle(color: AppColor.mainColor, fontSize: 14.sp),
                  ),
                ],
              )
            ],
          ),
          Text(
            'Absent',
            style: TextStyle(color: AppColor.mainColor, fontSize: 26.sp),
          ),
        ],
      ),
    );
  }
}
