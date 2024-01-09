import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/screens/audioplayer.dart';
import 'package:frontend/Views/utils/keys.dart';
import 'package:get/get.dart';

class WidgetController extends GetxController with keysforhistory {
  final RxList<Widget> widgets = <Widget>[].obs;

  void addWidget(List<MySoundscape> _soundscapes, MySoundscape soundscape) {
    List<List<String>>? twoDHkey = Hkeys(_soundscapes.length, 5);
    widgets.add(Material(
      elevation: 5,
      child: InkWell(
        onLongPress: null,
        onTap: () {
          Get.to(
              () => ClassAudioPlayer(
                  mySoundscape: soundscape,
                  code: 'history',
                  oneDHkey: twoDHkey![_soundscapes.indexOf(soundscape)]),
              transition: Transition.zoom,
              duration: const Duration(milliseconds: 150));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 0,
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0.3, 0.3),
                        blurRadius: 9,
                        spreadRadius: 1,
                        color: Color.fromARGB(255, 58, 55, 55))
                  ],
                  backgroundBlendMode: BlendMode.luminosity,
                  borderRadius: BorderRadius.circular(13)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                child: SizedBox(
                  child: Text(soundscape.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto')),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
