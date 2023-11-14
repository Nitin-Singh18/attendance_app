import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/app_color.dart';
import '../../../const/constants.dart';
import '../../../data/widget/c_button.dart';
import '../../../data/widget/tile.dart';
import '../../../services/local/shared_preferences.dart';
import '../../calendar/view/calendar_view.dart';
import '../../scanner/view/attendance_confirmation_view.dart';
import '../../scanner/view/scanner_view.dart';
import '../../setting/view/setting_view.dart';
import '../view_model/home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      addTodayAttendance();
    });
    super.initState();
  }

  void addTodayAttendance() async {
    SharedPref.open();
    await ref.read(homeViewModelProvider.notifier).createTodayAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final watchingProvider = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          '${watchingProvider.attendancePercentage.toStringAsFixed(2)}%',
          style: TextStyle(color: AppColor.mainColor, fontSize: 22.sp),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CalendarView())),
            icon: const Icon(
              Icons.calendar_month,
              color: AppColor.mainColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 14.0.w),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingView(),
                ),
              ),
              child: const Icon(
                Icons.settings,
                color: AppColor.mainColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: watchingProvider.attendanceItems.length,
          itemBuilder: (context, index) {
            final attendanceItem = watchingProvider.attendanceItems[index];
            return AttendanceTile(
              attendanceItem: attendanceItem,
            );
          },
        ),
      ),
      bottomNavigationBar: CButton(
        title: 'Scan',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ref.read(homeViewModelProvider).currentAttendance!.status !=
                          AppString.qrValue
                      ? const ScannerView(
                          scanType: ScanType.scan,
                        )
                      : const AttendanceConfirmationView(),
            ),
          );
        },
      ),
    );
  }
}
