import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/ViewModels/_Soundscape_service.dart';
import 'package:frontend/Views/utils/audioplayer.dart';
import 'package:frontend/Views/utils/keys.dart';
import 'package:frontend/Views/utils/soundscape_options.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManyChoiceChip extends StatefulWidget {
  final String code;
  final String? enteredword;
  const ManyChoiceChip({super.key, required this.code, this.enteredword});

  @override
  State<ManyChoiceChip> createState() => _ManyChoiceChipState();
}

class _ManyChoiceChipState extends State<ManyChoiceChip> with keysforhistory {
  Map<String, bool> playlists = {'All': true, 'Downloaded': false};
  late SoundscapeService _SoundscapeService;
  late Future<List<MySoundscape>> _soundscapes;
  final String djangoURL = dotenv.env['LOCALHOST_URL']!;
  final String animationURL = dotenv.env['ANIMATION_URL']!;
  late List<List<String>>? twoDHkey;
  List<String>? playlistName = [];
  SoundscapeOptions librarySoundscapeOptions = SoundscapeOptions();

  Widget loopchip(Map<String, bool> p) {
    List<Widget> chips = [];
    for (var entry in p.entries) {
      chips.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChoiceChip(
            label: Text(entry.key),
            selected: entry.value,
            selectedColor: const Color.fromARGB(255, 149, 121, 121),
            onSelected: (bool val) {
              setState(() {
                p[entry.key] = val;
              });
            }),
      ));
    }
    return Row(children: chips);
  }

  @override
  void initState() {
    super.initState();
    _SoundscapeService = SoundscapeService(djangoURL);
    _soundscapes = _SoundscapeService.getSoundscapes();
  }

  // ignore: non_constant_identifier_names
  Widget ManyHistorySoundGenerator(
      // ignore: no_leading_underscores_for_local_identifiers
      List<MySoundscape> _soundscapes,
      // ignore: non_constant_identifier_names
      List<String>? playlistNames,
      String? search_filter) {
    search_filter = search_filter?.toLowerCase();

    List<List<String>>? twoDHkey = Hkeys(playlistNames!.length, 5);
    List<Widget> generatorWidgets = playlistNames
        .where((playlistName) =>
            search_filter == null ||
            playlistName.toLowerCase().contains(search_filter))
        .map((historyscape) => Material(
              key: ValueKey(playlistNames.indexOf(historyscape)),
              elevation: 5,
              child: InkWell(
                onLongPress: null,
                onTap: () {
                  Get.to(
                    () => ClassAudioPlayer(
                      mySoundscape: librarySoundscapeOptions.soundscapefilter(
                          _soundscapes, historyscape),
                      oneDHkey: twoDHkey![playlistNames.indexOf(historyscape)],
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                        child: SizedBox(
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
      future: getPlaylistname(),
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
          return ManyChoiceChip(code: widget.code);
        } else {
          playlistName = snapshot.data;
          return futureWidget1();
        }
      },
    );
  }

  FutureBuilder<List<MySoundscape>> futureWidget1() {
    return FutureBuilder<List<MySoundscape>>(
      future: _soundscapes,
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
          if (playlists['All'] == true) {
            return Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: loopchip(playlists)),
                Expanded(
                    child: ManyHistorySoundGenerator(
                  snapshot.data!,
                  playlistName,
                  widget.enteredword,
                ))
              ],
            );
          } else {
            return Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: loopchip(playlists)),
                const Center(child: Text('All NOT SELECTED'))
              ],
            );
          }
        }
      },
    );
  }

  Future<List<String>?> getPlaylistname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? playlistName = prefs.getStringList('historysoundname__1');
    return playlistName;
  }
}
