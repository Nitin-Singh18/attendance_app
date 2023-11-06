import 'package:attendance_app/const/app_color.dart';
import 'package:attendance_app/data/widget/c_button.dart';
import 'package:attendance_app/data/widget/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.0.w),
            child: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.settings,
                color: AppColor.mainColor,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const AttendanceTile();
        },
      ),
      bottomNavigationBar: CButton(title: 'Scan', onTap: () {}),

      // Container(
      //   height: 60,
      //   color: Colors.white,
      //   padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 14.h),
      //   child: Container(),
      // ),
    );
  }
}
