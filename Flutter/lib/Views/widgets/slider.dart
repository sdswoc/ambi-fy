import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'dart:math';
import 'dart:async';

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

  const CustomSliderbar({super.key, required this.mySoundscape});

  @override
  State<CustomSliderbar> createState() => _CustomSliderbarState();
}

class _CustomSliderbarState extends State<CustomSliderbar> {
  List<AudioPlayer> _audioPlayer = [];
  Random random = Random();
  bool isPlaying = false;
  final int noOfPlayers = 5;
  List<String> audioUrl = [];

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
          if (widget.mySoundscape.elements[i].name == 'Birds') {
            Timer(Duration(seconds: 30), () async {
              int startPosition = random.nextInt(30);
              await _audioPlayer[i].seek(Duration(seconds: startPosition));
              _audioPlayer[i].play(DeviceFileSource(audioUrl[i]));

              // Stop after 10 seconds
              await Future.delayed(Duration(seconds: 10));
              await _audioPlayer[i].stop();
              //await _audioPlayer[i].setSource(DeviceFileSource(audioUrl[i]));
              //await _audioPlayer[i].play(DeviceFileSource(audioUrl[i]));
            });
          } else {
            _audioPlayer[i].setReleaseMode(ReleaseMode.loop);
            await _audioPlayer[i].play(DeviceFileSource(audioUrl[i]));
          }
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

  Future<void> _stop() async {
    for (int i = 0; i < noOfPlayers; i++) {
      await _audioPlayer[i].stop();
    }
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
            WaveSlider(audioPlayer: _audioPlayer[i]),
        ]),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              _pause();
            } else {
              _play();
            }
          },
        ),
      ],
    );
  }
}

class WaveSlider extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const WaveSlider({super.key, required this.audioPlayer});
  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  double bar2Position = 180.0;
  double volume = 1 / 350 * 0.5;

  _onTapDown(TapDownDetails details) {
    var y = 487.5479910714285552 - details.globalPosition.dy;
    print("tap down " + y.toString());
    setState(() {
      bar2Position = y;
      volume = 1 / 350 * bar2Position;
      widget.audioPlayer.setVolume(volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    int barItem = 0;
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          GestureDetector(
            onTapDown: (TapDownDetails details) => _onTapDown(details),
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                if (bar2Position <= 350 && bar2Position >= 0) {
                  bar2Position =
                      487.5479910714285552 - details.globalPosition.dy;
                  volume = 1 / 350 * bar2Position;
                  widget.audioPlayer.setVolume(volume);
                } else if (bar2Position > 350) {
                  bar2Position = 350;
                  volume = 1;
                  widget.audioPlayer.setVolume(volume);
                } else if (bar2Position < 0) {
                  bar2Position = 0;
                  volume = 0;
                  widget.audioPlayer.setVolume(volume);
                }

                print('drag position: $bar2Position');
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(38, 40, 2, 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: bars.map((int height) {
                      Color color = barItem + 1 < bar2Position / barWidth
                          ? Color(0xffec4b5d)
                          : Color(0xffec4b5d33);
                      barItem++;
                      return Container(
                        color: color,
                        height: height.toDouble(),
                        width: 5.0,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
