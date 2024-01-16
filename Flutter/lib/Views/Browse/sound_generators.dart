// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/ViewModels/view_model.dart';
import 'package:frontend/Views/Browse/check_permission.dart';
import 'package:frontend/Views/Browse/downloader.dart';
import 'package:frontend/Views/Common/audioplayer.dart';
import 'package:frontend/Views/utils/sound_generator_helper.dart';
import 'package:frontend/Views/Browse/bottomsheet_options.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
  final String animationURL = dotenv.env['ANIMATION_URL']!;
  late List<List<String>>? twoDHkey;
  List<String>? soundscapeName = [];
  List<String>? playlistName = [];
  late SoundGeneratorViewModel _viewModel;
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

  @override
  void initState() {
    super.initState();
    loadHistory('soundname__2');
    loadPlaylist('historysoundname__1');
    loadDownload('downloadsoundname__1');
    _viewModel = SoundGeneratorViewModel();
    checkPermission();
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
                    onTapSoundscape('soundname__2', soundscape);
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
                                                        HapticFeedback
                                                            .lightImpact();
                                                        onTapPlaylist(
                                                            'historysoundname__1',
                                                            soundscape);
                                                        Navigator.of(context)
                                                            .pop();

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                            'Added to playlist!',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                          duration: Duration(
                                                              seconds: 2),
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  48,
                                                                  47,
                                                                  47),
                                                        ));
                                                      },
                                                      child: const BottomSheetOptions(
                                                          message:
                                                              'Add to Playlists',
                                                          icon: Icon(Icons
                                                              .add_circle_outline))),
                                                  DownloaderWidget(
                                                      mySoundscape: soundscape,
                                                      oneDHkey: twoDHkey![
                                                          _soundscapes.indexOf(
                                                              soundscape)],
                                                      checkpermission:
                                                          checkPermission())
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
        future: _viewModel.loadSoundscapes(),
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
