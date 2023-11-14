import 'package:flutter/material.dart';

import '../../const/app_color.dart';

Future<DateTime?> pickedDateDialog(
  BuildContext context,
) async {
  late DateTime? selectedDate;
  return showDatePicker(
    builder: (context, child) {
      return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.mainColor,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.black,
                ),
              ),
            ),
          ),
          child: child!);
    },
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2022, 12, 1),
    lastDate: DateTime(2024, 1, 31),
  ).then((value) {
    selectedDate = value;
    return selectedDate;
  });
}
