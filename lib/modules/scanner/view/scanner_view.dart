import 'package:attendance_app/const/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../const/app_color.dart';
import '../../../services/local/shared_preferences.dart';
import '../view_model/scanner_view_model.dart';

enum ScanType { scan, save }

class ScannerView extends ConsumerStatefulWidget {
  final ScanType scanType;
  const ScannerView({required this.scanType, super.key});

  @override
  ConsumerState<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends ConsumerState<ScannerView> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    openSP();
    super.initState();
  }

  openSP() async {
    await SharedPref.open();
  }

  @override
  Widget build(BuildContext context) {
    final providerMethods = ref.read(scannerViewModelProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.backGroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300.h,
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: AppColor.mainColor.withOpacity(0.5), width: 4),
                ),
                child: MobileScanner(
                  controller: _scannerController,
                  onDetect: (BarcodeCapture code) {
                    switch (widget.scanType) {
                      case ScanType.scan:
                        providerMethods.markPresent(code, () {
                          showSnackBar(context);
                        });
                        _scannerController
                          ..stop()
                          ..dispose();
                      case ScanType.save:
                        providerMethods.saveQR(code);
                    }
                    // if (widget.scanType == ScanType.scan) {
                    //   providerMethods.markPresent(code, () {
                    //     print(
                    //         '----------------------------Callback called-----------------------------------------');
                    //     showSnackBar(context);
                    //   });
                    //   _scannerController
                    //     ..stop()
                    //     ..dispose();
                    // }
                    // if (widget.scanType == ScanType.save) {
                    //   providerMethods.saveQR(code);
                    // }
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                'Place your camera on QR code',
                style: TextStyle(fontSize: 16.sp, color: AppColor.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
