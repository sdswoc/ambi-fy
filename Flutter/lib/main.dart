import 'package:flutter/material.dart';
import 'package:frontend/Views/screens/browse.dart';
import 'package:frontend/Views/screens/history.dart';
import 'package:frontend/Views/screens/library.dart';
import 'package:frontend/Views/screens/more_ver.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', brightness: Brightness.dark),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SoundLibrary()),
        GetPage(name: '/history', page: () => const History()),
        GetPage(name: '/browse', page: () => const Browse()),
        GetPage(name: '/more', page: () => const MoreVer()),
      ],
    );
  }
}
