import 'package:flutter/material.dart';
import 'package:frontend/Views/utils/controller.dart';
import 'package:frontend/Views/widgets/bottom_navigation_bar.dart';
import 'package:frontend/Views/widgets/generators.dart';
import 'package:get/get.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isExpanded = false;
  String? _enteredword;
  static const String code = 'history';
  final WidgetController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 65,
            backgroundColor: Colors.black,
            title: const Text("History",
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
                  setState(() {
                    isExpanded = !isExpanded;
                  });
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
                          setState(() {
                            _enteredword = value;
                          });
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
                icon: Icon(Icons.delete_forever_rounded, color: Colors.white),
                iconSize: 27,
                onPressed: () {},
              ),
            ]),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              children: controller.widgets,
            ))
          ],
        ),
        bottomNavigationBar: const BottomNav(selectedIndex: 1));
  }
}
