import "package:flutter/material.dart";
import 'package:google_nav_bar/google_nav_bar.dart';

class SoundLibrary extends StatefulWidget {
  const SoundLibrary({super.key});

  @override
  State<SoundLibrary> createState() => _SoundLibraryState();
}

class _SoundLibraryState extends State<SoundLibrary> {
  int _selectedindex = 0;
  String _title = "";
  void _navigatebottombar(int index) {
    setState(() {
      _selectedindex = index;
      switch (index) {
        case 0:
          {
            _title = "Your Library";
          }
          break;
        case 1:
          {
            _title = "History";
          }
          break;
        case 2:
          {
            _title = "Browse";
          }
          break;
        case 3:
          {
            _title = "More";
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("$_title",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  wordSpacing: -2,
                  letterSpacing: -0.8)),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              iconSize: 24,
              onPressed: () {
                const TextField(style: TextStyle(color: Colors.white));
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              iconSize: 24,
              onPressed: () {},
            ),
          ]),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GNav(
              onTabChange: _navigatebottombar,
              selectedIndex: _selectedindex,
              backgroundColor: Colors.black,
              gap: 6,
              color: const Color.fromARGB(255, 87, 87, 87),
              activeColor: const Color.fromARGB(255, 255, 255, 255),
              iconSize: 24,
              tabBackgroundColor:
                  const Color.fromARGB(255, 110, 110, 110).withOpacity(0.25),
              padding: const EdgeInsets.all(10),
              tabs: const [
                GButton(icon: Icons.library_music, text: "Your Library"),
                GButton(icon: Icons.history, text: "History"),
                GButton(icon: Icons.browse_gallery_outlined, text: "Browse"),
                GButton(icon: Icons.more_horiz, text: "More")
              ]),
        ),
      ),
    );
  }
}
