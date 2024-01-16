import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/Common/slider.dart';
import 'package:get/get.dart';

class ClassAudioPlayer extends StatelessWidget {
  final MySoundscape mySoundscape;
  final List<String>? oneDHkey;
  final String? code;
  final List<String>? filepath;

  const ClassAudioPlayer(
      {super.key,
      required this.mySoundscape,
      this.oneDHkey,
      this.code,
      this.filepath});

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
            mySoundscape.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Roboto', fontSize: 22, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Row(children: [
              CustomSliderbar(
                mySoundscape: mySoundscape,
                oneDHkey: oneDHkey,
                code: code,
                filepath: filepath,
              ),
            ])
          ],
        ));
  }
}
