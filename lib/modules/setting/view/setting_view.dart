import 'package:attendance_app/const/constants.dart';
import 'package:attendance_app/data/widget/date_picker.dart';
import 'package:attendance_app/modules/home/view_model/home_view_model.dart';
import 'package:attendance_app/services/local/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/app_color.dart';
import '../../../data/widget/c_button.dart';
import '../../scanner/view/scanner_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});
  Future<void> _saveSelectedDate(DateTime pickedDate) async {
    final SharedPref prefs = SharedPref();
    await SharedPref.open();
    prefs.setString(AppString.startDateKey, pickedDate.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(color: AppColor.mainColor),
        ),
        iconTheme: const IconThemeData(color: AppColor.mainColor),
        backgroundColor: AppColor.backGroundColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: double.infinity,
            child: CButton(
              title: 'Save QR',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScannerView(
                    scanType: ScanType.save,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer(builder: (context, ref, child) {
              return CButton(
                  title: 'Select Starting Date',
                  onTap: () async {
                    final DateTime? pickedDate =
                        await pickedDateDialog(context);

                    if (pickedDate != null) {
                      await _saveSelectedDate(pickedDate);
                      ref
                          .read(homeViewModelProvider.notifier)
                          .calculateAttendancePercentage();
                    }
                  });
            }),
          )
        ],
      ),
    );
  }
}
