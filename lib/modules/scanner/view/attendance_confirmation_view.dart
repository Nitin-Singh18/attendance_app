import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../const/app_color.dart';
import '../../../data/widget/c_button.dart';

class AttendanceConfirmationView extends StatelessWidget {
  const AttendanceConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: AppColor.backGroundColor,
              alignment: Alignment.center,
              child: Text(
                'Attendance is marked for ${DateFormat('d MMM, EEE').format(DateTime.now())}',
                style: const TextStyle(color: AppColor.mainColor, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            CButton(title: 'Go Back', onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
