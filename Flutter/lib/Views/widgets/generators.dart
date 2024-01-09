import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/ViewModels/_Soundscape_service.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Views/screens/audioplayer.dart';
import 'package:frontend/Views/utils/controller.dart';
import 'package:frontend/Views/utils/keys.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/Models/_History.dart';

class SoundGenerator extends StatefulWidget {
  final String? enteredword;
  final String? code;

  const SoundGenerator({Key? key, this.enteredword, this.code})
      : super(key: key);

  SoundGeneratorState? getState() {
    return _key.currentState;
  }

  @override
  State<SoundGenerator> createState() => SoundGeneratorState();

  static final GlobalKey<SoundGeneratorState> _key =
      GlobalKey<SoundGeneratorState>();
}

class SoundGeneratorState extends State<SoundGenerator> with keysforhistory {
  // ignore: non_constant_identifier_names
  late SoundscapeService _SoundscapeService;
  late Future<List<MySoundscape>> _soundscapes;
  final String djangoURL = dotenv.env['LOCALHOST_URL']!;
  final String animationURL = dotenv.env['ANIMATION_URL']!;
  late List<List<String>>? twoDHkey;
  List<Widget> historyWidgets = [];
  final WidgetController controller = Get.put(WidgetController());

  @override
  void initState() {
    super.initState();
    _SoundscapeService = SoundscapeService(djangoURL);
    _soundscapes = _SoundscapeService.getSoundscapes();
  }

  Widget ManySoundGenerator(
      List<MySoundscape> _soundscapes, String? search_filter) {
    search_filter = search_filter?.toLowerCase();

    List<List<String>>? twoDHkey = Hkeys(_soundscapes.length, 5);
    List<Widget> generatorWidgets = _soundscapes
        .where((soundscape) =>
            search_filter == null ||
            soundscape.name.toLowerCase().contains(search_filter))
        .map((soundscape) => Material(
              elevation: 5,
              child: InkWell(
                onLongPress: null,
                onTap: () {
                  //-------------------------------------------
                  controller.addWidget(_soundscapes, soundscape);
                  //-------------------------------------------
                  Get.to(
                      () => ClassAudioPlayer(
                          mySoundscape: soundscape,
                          oneDHkey: twoDHkey![_soundscapes.indexOf(soundscape)],
                          code: widget.code),
                      transition: Transition.zoom,
                      duration: const Duration(milliseconds: 150));
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
                          child: Text(soundscape.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto')),
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

  List<Widget> getHistoryWidgets() {
    return historyWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return future();
  }

  FutureBuilder<List<MySoundscape>> future() {
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
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No elements found');
          } else {
            return ManySoundGenerator(snapshot.data!, widget.enteredword);
          }
        });
  }
}
