import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Views/Common/slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaveSlider extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String hkey;
  final String elementName;
  final String? code;

  const WaveSlider({
    super.key,
    this.code,
    required this.elementName,
    required this.audioPlayer,
    required this.hkey,
  });

  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  double bar2Position = 180.0;
  double volume = 1 / 351 * 180;

  _onTapDown(TapDownDetails details) async {
    final SharedPreferences bar2history = await SharedPreferences.getInstance();
    var y = 487.5479910714285552 - details.globalPosition.dy;
    print("tap down " + y.toString());
    setState(() {
      bar2Position = y;
      volume = 1 / 351 * bar2Position;
      bar2Position = 351 * volume;
      widget.audioPlayer.setVolume(volume);
      bar2history.setDouble(widget.hkey, bar2Position);
    });
  }

  _loadPosition() async {
    if (widget.code == 'history' || widget.code == 'library') {
      final SharedPreferences bar2history =
          await SharedPreferences.getInstance();
      double savedPosition = bar2history.getDouble(widget.hkey) ?? 180;
      setState(() {
        bar2Position = savedPosition;
        double volume = 1 / 351 * bar2Position;
        widget.audioPlayer.setVolume(volume);
      });
    }
  }

  resetVolume() async {
    final SharedPreferences bar2history = await SharedPreferences.getInstance();
    setState(() {
      bar2Position = 180;
      volume = 1 / 351 * 180;
    });
    widget.audioPlayer.setVolume(volume);
    bar2history.setDouble(widget.hkey, bar2Position);
  }

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  @override
  Widget build(BuildContext context) {
    int barItem = 0;
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Tooltip(
            message: widget.elementName,
            preferBelow: true,
            child: GestureDetector(
              onTapDown: (TapDownDetails details) => _onTapDown(details),
              onVerticalDragUpdate: (DragUpdateDetails details) async {
                final SharedPreferences bar2history =
                    await SharedPreferences.getInstance();
                setState(() {
                  if (bar2Position <= 351 && bar2Position >= 0) {
                    bar2Position =
                        487.5479910714285552 - details.globalPosition.dy;
                    volume = 1 / 351 * bar2Position;
                    bar2Position = 351 * volume;
                    widget.audioPlayer.setVolume(volume);
                  } else if (bar2Position > 351) {
                    bar2Position = 351;
                    volume = 1;
                    bar2Position = 351 * volume;
                    widget.audioPlayer.setVolume(volume);
                  } else if (bar2Position < 0) {
                    bar2Position = 0;
                    volume = 0;
                    bar2Position = 351 * volume;
                    widget.audioPlayer.setVolume(volume);
                  }
                  bar2history.setDouble(widget.hkey, bar2Position);
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
                            ? const Color.fromARGB(255, 215, 75, 92)
                            : const Color.fromARGB(235, 70, 86, 47);
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
          ),
        ],
      ),
    );
  }
}
