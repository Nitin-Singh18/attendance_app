import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/app_color.dart';

class CButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 4.h),
      child: SizedBox(
        height: 44.h,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColor.backGroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: const BorderSide(color: AppColor.mainColor))),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, color: AppColor.mainColor),
          ),
        ),
      ),
    );
  }
}
