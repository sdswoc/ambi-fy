import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/ViewModels/view_model.dart';
import 'package:frontend/Views/Browse/check_permission.dart';
import 'package:frontend/Views/Common/audioplayer.dart';
import 'package:frontend/Views/Library/container_soundscape.dart';
import 'package:frontend/Views/utils/sound_generator_helper.dart';
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
  final String animationURL = dotenv.env['ANIMATION_URL']!;
  late List<List<String>>? twoDHkey;
  late SoundGeneratorViewModel _libraryviewModel;
  List<String>? soundscapeName = [];
  List<String>? playlistName = [];
  List<String>? downloadName = [];
  List<String>? displayName = [];
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

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
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(
                    snackbarDisplay(),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  backgroundColor: Colors.grey.shade900,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.blue,
                    onPressed: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    },
                  ),
                ));
            }),
      ));
    }
    return Row(children: chips);
  }

  String snackbarDisplay() {
    if (playlists['All'] == true) {
      return 'Displaying All soundscapes!';
    } else if (playlists['All'] == false && playlists['Downloaded'] == false) {
      return 'No playlist selected!';
    } else {
      return 'Displaying Downloaded soundscapes!';
    }
  }

  @override
  void initState() {
    super.initState();
    _libraryviewModel = SoundGeneratorViewModel();
    loadHistory('soundname__2');
    checkPermission();
  }

  // ignore: non_constant_identifier_names
  Widget ManyLibrarySoundGenerator(
      // ignore: no_leading_underscores_for_local_identifiers
      List<MySoundscape> _soundscapes,
      // ignore: non_constant_identifier_names
      List<String>? playlistNames,
      String? search_filter,
      String code) {
    search_filter = search_filter?.toLowerCase();

    List<List<String>>? twoDHkey = Hkeys(playlistNames!.length, 5);
    List<Widget> generatorWidgets = playlistNames
        .where((playlistName) =>
            search_filter == null ||
            playlistName.toLowerCase().contains(search_filter))
        .map((playlistscape) => Material(
              key: ValueKey(playlistNames.indexOf(playlistscape)),
              elevation: 5,
              child: InkWell(
                onLongPress: null,
                onTap: () {
                  onTapSoundscape('soundname__2',
                      soundscapefilter(_soundscapes, playlistscape));
                  Get.to(
                    () => ClassAudioPlayer(
                      mySoundscape:
                          soundscapefilter(_soundscapes, playlistscape),
                      oneDHkey: twoDHkey![playlistNames.indexOf(playlistscape)],
                      code: widget.code,
                    ),
                    transition: Transition.zoom,
                    duration: const Duration(milliseconds: 150),
                  );
                },
                child: SoundscapeContainer(
                  name: playlistscape,
                  playlistNames: playlistNames,
                  playlistscape: playlistscape,
                  code: code,
                  onRemoveEntry: () {
                    setState(() {
                      if (playlists['All'] == false) {
                        loadDownload(code);
                      } else {
                        loadPlaylist(code);
                      }
                    });
                  },
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
          return Column(
            children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal, child: loopchip(playlists)),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 200, 8, 60),
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      '	ಠ__ಠ',
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                    Text(
                      "	Nothing's Here! ",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )),
              )
            ],
          );
        } else {
          displayName = snapshot.data;

          return futureWidget1();
        }
      },
    );
  }

  FutureBuilder<List<MySoundscape>> futureWidget1() {
    return FutureBuilder<List<MySoundscape>>(
      future: _libraryviewModel.loadSoundscapes(),
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
          if (playlists['All'] == false && playlists['Downloaded'] == false) {
            return Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: loopchip(playlists)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 200, 8, 60),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        '(=ʘᆽʘ=)∫',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                      Text(
                        'Select a playlist!',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
                )
              ],
            );
          } else {
            return Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: loopchip(playlists)),
                Expanded(
                    child: ManyLibrarySoundGenerator(snapshot.data!,
                        displayName, widget.enteredword, codeChoicechip()))
              ],
            );
          }
        }
      },
    );
  }

  Future<List<String>?> getPlaylistname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (playlists['All'] == true) {
      List<String>? playlistName = prefs.getStringList('historysoundname__1');
      return playlistName;
    } else {
      List<String>? downloadName = prefs.getStringList('downloadsoundname__1');
      return downloadName;
    }
  }
}
