import 'package:attendance_app/const/app_color.dart';
import 'package:attendance_app/data/widget/c_button.dart';
import 'package:attendance_app/data/widget/tile.dart';
import 'package:attendance_app/modules/home/view_model/home_view_model.dart';
import 'package:attendance_app/modules/scanner/view/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      body: ListView.builder(
        itemCount: watchingProvider.attendanceItems.length,
        itemBuilder: (context, index) {
          final attendanceItem = watchingProvider.attendanceItems[index];
          return AttendanceTile(
            attendanceItem: attendanceItem,
          );
        },
      ),
      bottomNavigationBar: CButton(
        title: 'Scan',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScannerView(),
            ),
          );
        },
      ),
    );
  }
}
