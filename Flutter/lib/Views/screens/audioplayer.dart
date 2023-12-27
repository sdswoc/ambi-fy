import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ClassAudioPlayer extends StatefulWidget {
  const ClassAudioPlayer({Key? key}) : super(key: key);

  @override
  State<ClassAudioPlayer> createState() => _ClassAudioPlayerState();
}

class _ClassAudioPlayerState extends State<ClassAudioPlayer> {
  late AudioPlayer _audioPlayer;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.setSourceUrl(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
      _audioPlayer.resume();
    }
  }

  void _changeVolume(double value) {
    setState(() {
      _volume = value;
    });
    _audioPlayer.setVolume(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AudioPlayerWidget(
          audioPlayer: _audioPlayer,
          onPlayPause: _playPause,
          volume: _volume,
          onVolumeChanged: _changeVolume,
        ),
      ],
    );
  }
}

class AudioPlayerWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final VoidCallback onPlayPause;
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const AudioPlayerWidget({
    required this.audioPlayer,
    required this.onPlayPause,
    required this.volume,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              audioPlayer.state == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 24.0,
            ),
            onPressed: onPlayPause,
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          SizedBox(height: 20.0),
          Material(
            child: Slider(
              value: volume,
              onChanged: onVolumeChanged,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: 'Volume',
            ),
          ),
        ],
      ),
    );
  }
}
