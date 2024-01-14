import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Views/Browse/browse.dart';
import 'package:frontend/Views/History/history.dart';
import 'package:frontend/Views/Library/library.dart';
import 'package:frontend/Views/More/more_ver.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load();
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
        GetPage(
            name: '/',
            page: () => const SoundLibrary(),
            transition: Transition.native,
            transitionDuration: const Duration(milliseconds: 100)),
        GetPage(
            name: '/history',
            page: () => const History(),
            transition: Transition.native,
            transitionDuration: const Duration(milliseconds: 100)),
        GetPage(
            name: '/browse',
            page: () => const Browse(),
            transition: Transition.native,
            transitionDuration: const Duration(milliseconds: 100)),
        GetPage(
            name: '/more',
            page: () => const MoreVer(),
            transition: Transition.native,
            transitionDuration: const Duration(milliseconds: 100)),
      ],
    );
  }
}
