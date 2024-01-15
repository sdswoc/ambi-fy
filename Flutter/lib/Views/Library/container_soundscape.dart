import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundscapeContainer extends StatefulWidget {
  final String name;
  final List<String>? playlistNames;
  final String playlistscape;
  final String code;
  final VoidCallback onRemoveEntry;

  const SoundscapeContainer({
    super.key,
    required this.name,
    required this.playlistNames,
    required this.playlistscape,
    required this.code,
    required this.onRemoveEntry,
  });

  @override
  State<SoundscapeContainer> createState() => _SoundscapeContainerState();
}

class _SoundscapeContainerState extends State<SoundscapeContainer> {
  Future<void> saveSoundscapename(String key, List<String>? soundscapes) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    historyprefs.setStringList(key, soundscapes!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    widget.name,
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
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return List.generate(1, (index) {
                    return PopupMenuItem(
                        child: MaterialButton(
                      child: const Text(
                        'Remove Entry',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.playlistNames!.remove(widget.playlistscape);
                          saveSoundscapename(widget.code, widget.playlistNames);
                          widget.onRemoveEntry();
                          Navigator.of(context).pop();
                        });
                      },
                    ));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
