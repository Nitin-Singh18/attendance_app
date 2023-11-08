import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/app_color.dart';
import '../../../data/widget/c_button.dart';
import '../../scanner/view/scanner_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

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
        ],
      ),
    );
  }
}
