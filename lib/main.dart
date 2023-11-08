import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'modules/home/view/home_view.dart';
import 'services/local/isar_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDatabase.openDatabase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attendance App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeView(),
        );
      },
    );
  }
}
