// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/ViewModels/_Soundscape_service.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/utils/audioplayer.dart';
import 'package:frontend/Views/utils/keys.dart';
import 'package:frontend/Views/Browse/bottomsheet_options.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundGenerator extends StatefulWidget {
  final String? enteredword;
  final String? code;

  const SoundGenerator({Key? key, this.enteredword, this.code})
      : super(key: key);

  @override
  State<SoundGenerator> createState() => SoundGeneratorState();
}

class SoundGeneratorState extends State<SoundGenerator> with keysforhistory {
  // ignore: non_constant_identifier_names
  late SoundscapeService _SoundscapeService;
  late Future<List<MySoundscape>> _soundscapes;
  final String djangoURL = dotenv.env['LOCALHOST_URL']!;
  final String animationURL = dotenv.env['ANIMATION_URL']!;
  late List<List<String>>? twoDHkey;
  List<String>? soundscapeName = [];
  List<String>? playlistName = [];

  @override
  void initState() {
    super.initState();
    _SoundscapeService = SoundscapeService(djangoURL);
    _soundscapes = _SoundscapeService.getSoundscapes();
    _loadHistory('soundname__2');
    _loadPlaylist('historysoundname__1');
  }

  Future<void> _loadHistory(String key) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    soundscapeName = historyprefs.getStringList(key) ?? [];
  }

  Future<void> _loadPlaylist(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    playlistName = prefs.getStringList(key) ?? [];
  }

  Future<void> _onTapSoundscape(String key, MySoundscape soundscape) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    soundscapeName!.add(soundscape.name);
    historyprefs.setStringList(key, soundscapeName!);
  }

  Future<void> _onTapPlaylist(String key, MySoundscape soundscape) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    playlistName!.add(soundscape.name);
    historyprefs.setStringList(key, playlistName!);
  }

  // ignore: non_constant_identifier_names
  Widget ManySoundGenerator(
      // ignore: non_constant_identifier_names
      List<MySoundscape> _soundscapes,
      String? search_filter) {
    search_filter = search_filter?.toLowerCase();

    List<List<String>>? twoDHkey = Hkeys(_soundscapes.length, 5);
    List<Widget> generatorWidgets = _soundscapes
        .where((soundscape) =>
            search_filter == null ||
            soundscape.name.toLowerCase().contains(search_filter))
        .map((soundscape) => Material(
              key: ValueKey(_soundscapes.indexOf(soundscape)),
              elevation: 5,
              child: InkWell(
                  onLongPress: null,
                  onTap: () {
                    //-------------------------------------------
                    _onTapSoundscape('soundname__2', soundscape);
                    //-------------------------------------------
                    Get.to(
                      () => ClassAudioPlayer(
                        mySoundscape: soundscape,
                        oneDHkey: twoDHkey![_soundscapes.indexOf(soundscape)],
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
                                  color: Color.fromARGB(255, 58, 55, 55))
                            ],
                            backgroundBlendMode: BlendMode.luminosity,
                            borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                          child: SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(soundscape.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto')),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            useSafeArea: true,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            30))),
                                            barrierColor:
                                                Colors.black87.withOpacity(0.5),
                                            builder: (BuildContext context) {
                                              return ListView(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        _onTapPlaylist(
                                                            'historysoundname__1',
                                                            soundscape);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const BottomSheetOptions(
                                                          message:
                                                              'Add to Playlists',
                                                          icon: Icon(Icons
                                                              .add_circle_outline))),
                                                  GestureDetector(
                                                      onTap: () {},
                                                      child: const BottomSheetOptions(
                                                          message:
                                                              'Download Soundscape',
                                                          icon: Icon(Icons
                                                              .download_for_offline_outlined)))
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.white, size: 27)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ))
        .toList();

    return ListView(children: generatorWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return futureWidget();
  }

//Fetching data
  FutureBuilder<List<MySoundscape>> futureWidget() {
    return FutureBuilder<List<MySoundscape>>(
        future: _soundscapes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Lottie.network(animationURL,
                frameRate: FrameRate.max,
                repeat: true,
                reverse: false,
                height: 200,
                width: 200);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error ?? "Unknown error"}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No elements found');
          } else {
            return ManySoundGenerator(snapshot.data!, widget.enteredword);
          }
        });
  }
}
