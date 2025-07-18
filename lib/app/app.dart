import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nurahelp/app/nav_menu.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: kIsWeb,
        builder: (context) => GetMaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins'
        ),
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        home: NavigationMenu()
      ),
    );
  }
}