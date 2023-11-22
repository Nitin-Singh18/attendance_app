import 'package:attendance_app/data/widget/c_button.dart';
import 'package:attendance_app/data/widget/tile.dart';
import 'package:attendance_app/main.dart';
import 'package:attendance_app/services/local/isar_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    await IsarDatabase.openDatabase();
  });
  testWidgets('App', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 4));

    final percentTextFinder = find.text('0.00%');
    expect(percentTextFinder, findsOneWidget);

    final attendanceTileFinder = find.byType(AttendanceTile);
    expect(attendanceTileFinder, findsOneWidget);

    final currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final currentDateTileFinder = find.widgetWithText(
        AttendanceTile, DateFormat('d MMM, EEE').format(currentDate));
    expect(currentDateTileFinder, findsOneWidget);

    final absentTextFinder = find.widgetWithText(AttendanceTile, 'Absent');
    expect(absentTextFinder, findsOneWidget);

    final calendarIconFinder = find.byIcon(Icons.calendar_month);
    expect(calendarIconFinder, findsOneWidget);
    await tester.tap(calendarIconFinder);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    final currentCalendarDateFinder = find.byWidgetPredicate((widget) {
      return widget is TableCalendar &&
          widget.focusedDay.day == currentDate.day;
    });
    expect(currentCalendarDateFinder, findsOneWidget);

    // final leftChevronIconFinder = find.byWidgetPredicate((widget) {
    //   return widget is TableCalendar &&
    //       widget.headerStyle.leftChevronIcon == const Icon(Icons.chevron_left);
    // });
    // expect(leftChevronIconFinder, findsOneWidget);
    // await tester.tap(leftChevronIconFinder);
    //
    // final rightChevronIconFinder = find.byWidgetPredicate((widget) {
    //   return widget is TableCalendar &&
    //       widget.headerStyle.rightChevronIcon ==
    //           const Icon(Icons.chevron_right);
    // });
    // expect(rightChevronIconFinder, findsOneWidget);
    // await tester.tap(rightChevronIconFinder);

    final backButtonFinder = find.byIcon(Icons.arrow_back);
    expect(backButtonFinder, findsOneWidget);
    await tester.tap(backButtonFinder);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    final settingIconFinder = find.byIcon(Icons.settings);
    expect(settingIconFinder, findsOneWidget);
    await tester.tap(settingIconFinder);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    final selectStartingDateButton = find.byType(CButton).at(1);
    expect(selectStartingDateButton, findsOneWidget);
    await tester.tap(selectStartingDateButton);

    await tester.pump();
    await Future.delayed(const Duration(seconds: 4));

    final dateFinder = find.text(
        DateFormat('d').format(currentDate.subtract(const Duration(days: 5))));

    expect(dateFinder, findsOneWidget);
    await tester.tap(dateFinder);

    await tester.pump();
    await Future.delayed(const Duration(seconds: 2));

    final okTextButtonFinder = find.text('OK');
    expect(okTextButtonFinder, findsOneWidget);
    await tester.tap(okTextButtonFinder);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    await tester.tap(backButtonFinder);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
  });
}
