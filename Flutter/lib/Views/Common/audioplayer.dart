import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/Common/slider.dart';
import 'package:get/get.dart';

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
        ),
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
