import 'package:frontend/Models/_Soundscape.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundscapeOptions {
  MySoundscape soundscapefilter(
      List<MySoundscape> _soundscapes, String soundscapename) {
    MySoundscape? returnSoundscape;

    for (int i = 0; i < _soundscapes.length; i++) {
      if (_soundscapes[i].name == soundscapename) {
        returnSoundscape = _soundscapes[i];
        break;
      }
    }

    return returnSoundscape ?? MySoundscape(name: '', elements: []);
  }

  Future<void> load(String key, List<String>? soundscapeName) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    soundscapeName = historyprefs.getStringList(key) ?? [];
  }

  Future<void> OnTap(
      String key, List<String>? soundscapeName, MySoundscape soundscape) async {
    final SharedPreferences historyprefs =
        await SharedPreferences.getInstance();
    soundscapeName!.add(soundscape.name);
    historyprefs.setStringList(key, soundscapeName);
  }
}
