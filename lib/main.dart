import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constant/theme/theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_names.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hash Attendance',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      getPages: AppPages.appPages,
      initialRoute: RouteNames.home,
    );
  }
}
