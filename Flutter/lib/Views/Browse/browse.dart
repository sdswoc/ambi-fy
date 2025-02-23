import 'package:flutter/material.dart';
import 'package:frontend/Views/Common/bottom_navigation_bar.dart';
import 'package:frontend/Views/Browse/sound_generators.dart';

class Browse extends StatefulWidget {
  const Browse({super.key});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  bool isExpanded = false;
  String? _enteredword;
  static const String code = 'library';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 65,
            backgroundColor: Colors.black,
            title: const Text("Browse",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    wordSpacing: -2,
                    letterSpacing: -0.8)),
            actions: [
              IconButton(
                icon: isExpanded
                    ? (const Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ))
                    : (const Icon(Icons.search, color: Colors.white)),
                iconSize: 27,
                onPressed: () {
                  // ignore: unnecessary_this
                  if (this.mounted) {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  }
                },
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: isExpanded ? 315.0 : 0.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: null,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: isExpanded
                    ? TextField(
                        style: TextStyle(color: Colors.grey[350]),
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _enteredword = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey[350],
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey[350]),
                          contentPadding: const EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      )
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                iconSize: 27,
                onPressed: () {},
              ),
            ]),
        body: Column(
          children: [
            Expanded(
                child: SoundGenerator(enteredword: _enteredword, code: code))
          ],
        ),
        bottomNavigationBar: const BottomNav(
          selectedIndex: 2,
        ));
  }
}
