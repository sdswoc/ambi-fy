import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';

class BottomNav extends StatefulWidget {
  final int selectedIndex;
  const BottomNav({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _switchPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        {
          Get.offAllNamed('/');
          break;
        }

      case 1:
        {
          Get.offAllNamed('/history');
          break;
        }
      case 2:
        {
          Get.offAllNamed('/browse');
          break;
        }
      case 3:
        {
          Get.offAllNamed('/more');
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(15), bottom: Radius.zero)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GNav(
          onTabChange: _switchPage,
          selectedIndex: widget.selectedIndex,
          backgroundColor: Colors.black,
          gap: 6,
          color: const Color.fromARGB(255, 87, 87, 87),
          activeColor: const Color.fromARGB(255, 255, 255, 255),
          iconSize: 27,
          tabBackgroundColor:
              const Color.fromARGB(255, 110, 110, 110).withOpacity(0.25),
          padding: const EdgeInsets.all(10),
          tabs: const [
            GButton(icon: Icons.library_music, text: 'Your Library'),
            GButton(icon: Icons.history, text: 'History'),
            GButton(icon: Icons.browse_gallery_outlined, text: 'Browse'),
            GButton(icon: Icons.more_horiz, text: 'More')
          ],
        ),
      ),
    );
  }
}
