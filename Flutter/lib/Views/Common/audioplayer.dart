import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/Common/slider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassAudioPlayer extends StatefulWidget {
  final MySoundscape mySoundscape;
  final List<String> oneDHkey;
  final String? code;

  const ClassAudioPlayer({
    super.key,
    required this.mySoundscape,
    required this.oneDHkey,
    this.code,
  });

  @override
  State<ClassAudioPlayer> createState() => _ClassAudioPlayerState();
}

class _ClassAudioPlayerState extends State<ClassAudioPlayer> {
  double bar2Position = 0.0;

  Future<void> updateAndSaveBar2Position(double newPosition) async {
    final SharedPreferences bar2history = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      double newPosition = /*bar2history.getDouble(widget.oneDHkey[i]) ??*/ 180;
      setState(() {
        bar2Position = newPosition;
        bar2history.setDouble(widget.oneDHkey[i], bar2Position);
      });
    }
  }

  void restartPlayer() {
    updateAndSaveBar2Position(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              widget.mySoundscape.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Roboto', fontSize: 22, color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    restartPlayer();
                  },
                ),
              )
            ]),
        body: Column(
          children: [
            Row(children: [
              CustomSliderbar(
                mySoundscape: widget.mySoundscape,
                oneDHkey: widget.oneDHkey,
                code: widget.code,
              ),
            ])
          ],
        ));
  }
}
