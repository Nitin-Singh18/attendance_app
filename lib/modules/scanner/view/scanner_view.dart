import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../const/app_color.dart';
import '../view_model/scanner_view_model.dart';

class ScannerView extends ConsumerStatefulWidget {
  const ScannerView({super.key});

  @override
  ConsumerState<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends ConsumerState<ScannerView> {
  final MobileScannerController _scannerController = MobileScannerController();

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
                    providerMethods.markPresent(code);
                    _scannerController
                      ..stop()
                      ..dispose();

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
