import 'package:attendance_app/modules/home/view_model/home_view_model.dart';
import 'package:attendance_app/services/local/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final scannerViewModelProvider =
    StateNotifierProvider<ScannerViewModel, DateTime>(
        (ref) => ScannerViewModel(ref: ref));

class ScannerViewModel extends StateNotifier<DateTime> {
  final Ref ref;
  ScannerViewModel({required this.ref}) : super(DateTime.now());

  IsarDatabase db = IsarDatabase();

  Future<void> markPresent(BarcodeCapture rawData) async {
    final String data =
        (rawData.raw[0] as Map<dynamic, dynamic>)['displayValue'];
    final currentAttendanceItem =
        ref.read(homeViewModelProvider).currentAttendance;
    if (currentAttendanceItem != null) {
      await db.updateAttendance(data, state, currentAttendanceItem);
      ref
          .read(homeViewModelProvider.notifier)
          .updateAttendanceStatus(data, state, currentAttendanceItem.date);
    }
  }
}
