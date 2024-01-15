import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'dart:math';
import 'dart:async';
import 'package:frontend/Views/Common/waveslider.dart';

List<int> bars = [];
const barWidth = 5.0;
late double screenWidth;
const int numberOfBars = 70;

void barLength() {
  for (var i = 0; i < numberOfBars; i++) {
    bars.add(35);
  }
}

class CustomSliderbar extends StatefulWidget {
  final MySoundscape mySoundscape;
  final List<String>? oneDHkey;
  final String? code;

  const CustomSliderbar({
    super.key,
    required this.mySoundscape,
    this.oneDHkey,
    this.code,
  });

  @override
  State<CustomSliderbar> createState() => _CustomSliderbarState();
}

class _CustomSliderbarState extends State<CustomSliderbar> {
  List<AudioPlayer> _audioPlayer = [];
  Random random = Random();
  bool isPlaying = false;
  final int noOfPlayers = 5;
  List<String> audioUrl = [];
  bool hasVolume = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = List.generate(noOfPlayers, (index) => AudioPlayer());
    audioUrl = List.filled(noOfPlayers, '');
  }

  Future<void> _play() async {
    try {
      if (widget.mySoundscape.elements.isNotEmpty) {
        for (int i = 0; i < noOfPlayers; i++) {
          audioUrl[i] = widget.mySoundscape.elements[i].audio;
          await _audioPlayer[i].stop();
          _audioPlayer[i].setReleaseMode(ReleaseMode.loop);
          await _audioPlayer[i].play(DeviceFileSource(audioUrl[i]));
        }
        setState(() {
          isPlaying = true;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _pause() async {
    try {
      for (int i = 0; i < noOfPlayers; i++) {
        await _audioPlayer[i].pause();
      }
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < noOfPlayers; i++) {
      _audioPlayer[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) {
      barLength();
    }
    return Column(
      children: [
        Row(children: [
          for (int i = 0; i < noOfPlayers; i++)
            WaveSlider(
              elementName: widget.mySoundscape.elements[i].name,
              audioPlayer: _audioPlayer[i],
              hkey: widget.oneDHkey![i],
              code: widget.code,
            )
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(45, 80, 8, 16),
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255), width: 4),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                child: Center(
                  child: IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 80,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      if (isPlaying) {
                        _pause();
                      } else {
                        _play();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
