// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/ViewModels/view_model.dart';
import 'package:frontend/Views/Common/audioplayer.dart';
import 'package:frontend/Views/utils/sound_generator_helper.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistorySoundGenerator extends StatefulWidget {
  final String? enteredword;
  final String? code;

  // ignore: use_super_parameters
  const HistorySoundGenerator({Key? key, this.enteredword, this.code})
      : super(key: key);

  @override
  State<HistorySoundGenerator> createState() => HistorySoundGeneratorState();
}

class HistorySoundGeneratorState extends State<HistorySoundGenerator>
    with keysforhistory {
  // ignore: non_constant_identifier_names
  final String animationURL = dotenv.env['ANIMATION_URL']!;
  late List<List<String>>? twoDHkey;
  late List<String>? soundscapeName;
  late SoundGeneratorViewModel _historyviewModel;

  @override
  void initState() {
    super.initState();
    _historyviewModel = SoundGeneratorViewModel();
  }

  Future<void> saveSoundscapename(String key, List<String> soundscapes) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    historyprefs.setStringList(key, soundscapes);
  }

  // ignore: non_constant_identifier_names
  Widget ManyHistorySoundGenerator(
      List<MySoundscape> _soundscapes,
      // ignore: non_constant_identifier_names
      List<String>? soundscapeNames,
      String? search_filter) {
    search_filter = search_filter?.toLowerCase();

    List<List<String>>? twoDHkey = Hkeys(soundscapeNames!.length, 5);
    List<Widget> generatorWidgets = soundscapeNames
        .where((soundscapeName) =>
            search_filter == null ||
            soundscapeName.toLowerCase().contains(search_filter))
        .map((historyscape) => Material(
              key: ValueKey(soundscapeNames.indexOf(historyscape)),
              elevation: 5,
              child: InkWell(
                onLongPress: null,
                onTap: () {
                  Get.to(
                    () => ClassAudioPlayer(
                      mySoundscape:
                          soundscapefilter(_soundscapes, historyscape),
                      oneDHkey:
                          twoDHkey![soundscapeNames.indexOf(historyscape)],
                      code: widget.code,
                    ),
                    transition: Transition.zoom,
                    duration: const Duration(milliseconds: 150),
                  );
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
                            color: Color.fromARGB(255, 58, 55, 55),
                          )
                        ],
                        backgroundBlendMode: BlendMode.luminosity,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                historyscape,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 120),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                soundscapeNames.remove(historyscape);
                                saveSoundscapename(
                                    'soundname__2', soundscapeNames);
                              });
                            },
                            icon: const Icon(Icons.delete_rounded, size: 28),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
        .toList();

    return ListView(children: generatorWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: getSoundscapename(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              animationURL,
              frameRate: FrameRate.max,
              repeat: true,
              reverse: false,
              height: 200,
              width: 200,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error ?? "Unknown error"}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(8, 240, 8, 0),
            child: Center(
                child: Column(
              children: [
                Center(
                    child: Text(
                  ' (ー_ー)!!',
                  style: TextStyle(fontSize: 50),
                )),
                Center(child: Text('Empty History')),
              ],
            )),
          );
        } else {
          soundscapeName = snapshot.data!;
          return futureWidget1();
        }
      },
    );
  }

  FutureBuilder<List<MySoundscape>> futureWidget1() {
    return FutureBuilder<List<MySoundscape>>(
      future: _historyviewModel.loadSoundscapes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              animationURL,
              frameRate: FrameRate.max,
              repeat: true,
              reverse: false,
              height: 200,
              width: 200,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error ?? "Unknown error"}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No elements found');
        } else {
          return ManyHistorySoundGenerator(
            snapshot.data!,
            soundscapeName,
            widget.enteredword,
          );
        }
      },
    );
  }

  Future<List<String>?> getSoundscapename() async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    List<String>? soundscapeName = historyprefs.getStringList('soundname__2');
    return soundscapeName;
  }
}
