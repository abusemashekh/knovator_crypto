import 'package:flutter/material.dart';
import 'package:flutter_task/modules/splash/views/splash_screen.dart';
import 'package:get/get.dart';
import 'modules/portfolio/views/portfolio_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: SplashScreen(),
    ),
  );
}
