import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape.dart';

List<int> bars = [];
const barWidth = 5.0;
late double screenWidth;
late int numberOfBars;

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
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _play() async {
    try {
      if (widget.mySoundscape.elements.isNotEmpty) {
        String audioUrl = widget.mySoundscape.elements[0].audio;

        await _audioPlayer.stop();

        // var source = await _audioPlayer.toPlayer(audioUrl);

        await _audioPlayer.play(DeviceFileSource(audioUrl));
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
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) {
      numberOfBars = 70;
      barLength();
    }
    return Column(
      children: [
        Row(children: [
          (WaveSlider(mySoundscape: widget.mySoundscape)),
          (WaveSlider(mySoundscape: widget.mySoundscape)),
          (WaveSlider(mySoundscape: widget.mySoundscape)),
          (WaveSlider(mySoundscape: widget.mySoundscape)),
          (WaveSlider(mySoundscape: widget.mySoundscape))
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
  final MySoundscape mySoundscape;

  const WaveSlider({super.key, required this.mySoundscape});
  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  double bar2Position = 180.0;

  _onTapUp(TapUpDetails details) {
    var y = details.globalPosition.dy;
    print("tap up " + y.toString());
    setState(() {
      bar2Position = y;
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
            onTapUp: (TapUpDetails details) => _onTapUp(details),
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                bar2Position = details.globalPosition.dy;
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
