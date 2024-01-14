import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/utils/slider.dart';
import 'package:frontend/Views/utils/waveslider.dart';
import 'package:get/get.dart';

class ClassAudioPlayer extends StatefulWidget {
  final MySoundscape mySoundscape;
  final List<String>? oneDHkey;
  final String? code;

  const ClassAudioPlayer({
    super.key,
    required this.mySoundscape,
    this.oneDHkey,
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
                    //widget.wavesliderstate?.resetVolume();
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
