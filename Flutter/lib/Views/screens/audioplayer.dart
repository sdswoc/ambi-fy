import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/widgets/slider.dart';
import 'package:get/get.dart';

class ClassAudioPlayer extends StatefulWidget {
  final MySoundscape mySoundscape;

  const ClassAudioPlayer({super.key, required this.mySoundscape});

  @override
  State<ClassAudioPlayer> createState() => _ClassAudioPlayerState();
}

class _ClassAudioPlayerState extends State<ClassAudioPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              icon: Icon(
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
            )),
        body: Column(
          children: [
            Row(children: [
              CustomSliderbar(mySoundscape: widget.mySoundscape),
            ])
          ],
        ));
  }
}
