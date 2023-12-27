import 'package:flutter/material.dart';
import 'package:frontend/Views/screens/audioplayer.dart';
import 'package:frontend/Views/screens/browse.dart';
import 'package:frontend/Views/screens/history.dart';
import 'package:frontend/Views/screens/library.dart';
import 'package:frontend/Views/screens/more_ver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', brightness: Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (context) => const SoundLibrary(),
        '/history': (context) => const History(),
        '/audioplayer': (context) => ClassAudioPlayer(),
        '/browse': (context) => const Browse(),
        '/more': (context) => MoreVer()
      },
    );
  }
}
