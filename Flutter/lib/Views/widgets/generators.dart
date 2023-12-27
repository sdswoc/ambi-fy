import 'package:flutter/material.dart';
import 'package:frontend/Models/_Soundscape_service.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:lottie/lottie.dart';

class SoundGenerator extends StatefulWidget {
  const SoundGenerator({super.key});

  @override
  State<SoundGenerator> createState() => _SoundGeneratorState();
}

class _SoundGeneratorState extends State<SoundGenerator> {
  List<Widget> generators = [];
  late SoundscapeService _SoundscapeService;
  late Future<List<MySoundscape>> _soundscapes;

  Widget ManySoundGenerator(List<MySoundscape> _soundscapes) {
    generators.clear();
    for (int i = 0; i < _soundscapes.length; i++) {
      generators.add(InkWell(
        onLongPress: null,
        onTap: () {
          Navigator.pushNamed(context, '/audioplayer');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.grey[600],
                backgroundBlendMode: BlendMode.luminosity,
                borderRadius: BorderRadius.circular(13)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
              child: SizedBox(
                child: Text(_soundscapes[i].name,
                    style: const TextStyle(
                        color: Colors.white, // Set the text color
                        fontSize: 24, // Set the font size
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto')),
              ),
            ),
          ),
        ),
      ));
    }
    return ListView(children: generators);
  }

  @override
  void initState() {
    super.initState();
    _SoundscapeService = SoundscapeService('http://10.0.2.2:8000');
    _soundscapes = _SoundscapeService.getSoundscapes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MySoundscape>>(
        future: _soundscapes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Lottie.network(
                'https://lottie.host/361fdbf1-7e86-481a-b50b-9c6cefc18f17/jHBUsYiFeW.json',
                frameRate: FrameRate.max,
                repeat: true,
                reverse: false,
                height: 200,
                width: 200); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No elements found');
          } else {
            return ManySoundGenerator(snapshot.data!);
          }
          ;
        });
  }
}
