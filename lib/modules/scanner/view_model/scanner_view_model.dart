import 'dart:ui';
import 'package:attendance_app/const/constants.dart';
import 'package:attendance_app/services/local/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../services/local/isar_db.dart';
import '../../home/view_model/home_view_model.dart';

final scannerViewModelProvider =
    StateNotifierProvider<ScannerViewModel, DateTime>(
        (ref) => ScannerViewModel(ref: ref));

class ScannerViewModel extends StateNotifier<DateTime> {
  final Ref ref;
  ScannerViewModel({required this.ref}) : super(DateTime.now());

  IsarDatabase db = IsarDatabase();
  final pref = SharedPref();

  Future<void> markPresent(
      BarcodeCapture rawData, VoidCallback invalidQRCallBack) async {
    final data = _getQRData(rawData);
    final String? qrValue = await getQR();

    if (qrValue != null) {
      if (qrValue == data) {
        final currentAttendanceItem =
            ref.read(homeViewModelProvider).currentAttendance;
        if (currentAttendanceItem != null) {
          await db.updateAttendance(data, state, currentAttendanceItem);
          ref.read(homeViewModelProvider.notifier).updateTodayAttendanceState(
              data, state, currentAttendanceItem.date);
        }
      } else {
        invalidQRCallBack();
      }
    } else {
      invalidQRCallBack();
    }
  }

  String _getQRData(BarcodeCapture rawData) {
    return (rawData.raw[0] as Map<dynamic, dynamic>)['displayValue'];
  }

  Future<void> saveQR(BarcodeCapture rawData) async {
    final data = _getQRData(rawData);
    pref.setString(AppString.qrKey, data);
  }

  Future<String?> getQR() async {
    return pref.getString(AppString.qrKey);
  }
}
