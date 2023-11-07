import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/app_color.dart';
import '../../../data/widget/c_button.dart';
import '../../../data/widget/tile.dart';
import '../../scanner/view/attendance_confirmation_view.dart';
import '../../scanner/view/scanner_view.dart';
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
    await ref.read(homeViewModelProvider.notifier).createTodayAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final watchingProvider = ref.watch(homeViewModelProvider);
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
                  ref.read(homeViewModelProvider).currentAttendance != null
                      ? const ScannerView()
                      : const AttendanceConfirmationView(),
            ),
          );
        },
      ),
    );
  }
}
