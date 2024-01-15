import 'package:frontend/Models/_Soundscape.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String>? soundscapeName = [];
List<String>? playlistName = [];
List<String>? downloadName = [];
Map<String, bool> playlists = {'All': true, 'Downloaded': false};

mixin keysforhistory {
  List<List<String>>? Hkeys(
    int m,
    int n,
  ) {
    List<List<String>>? twodkey = [];

    for (int j = 0; j < m; j++) {
      List<String>? onedkey = [];

      for (int i = 0; i < n; i++) {
        onedkey.add('HKEY_${j}_${i}_');
      }

      twodkey.add(onedkey);
    }

    return twodkey;
  }
}

void loadHistory(String key) async {
  final SharedPreferences historyprefs = await SharedPreferences.getInstance();
  soundscapeName = historyprefs.getStringList(key) ?? [];
}

void loadPlaylist(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  playlistName = prefs.getStringList(key) ?? [];
}

void sortListAscending(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (playlists['All'] == true) {
    playlistName!.sort();
    prefs.setStringList(key, playlistName!);
  } else if (playlists['Downloaded'] == true && playlists['All'] == false) {
    downloadName!.sort();
    prefs.setStringList(key, downloadName!);
  }
}

String codeChoicechip() {
  if (playlists['Downloaded'] == true && playlists['All'] == false) {
    return 'downloadsoundname__1';
  } else {
    return 'historysoundname__1';
  }
}

void sortListDescending(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (playlists['All'] == true) {
    playlistName!.sort((a, b) => b.compareTo(a));
    prefs.setStringList(key, playlistName!);
  } else if (playlists['Downloaded'] == true && playlists['All'] == false) {
    downloadName!.sort((a, b) => b.compareTo(a));
    prefs.setStringList(key, downloadName!);
  }
}

void loadDownload(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  downloadName = prefs.getStringList(key) ?? [];
}

void onTapSoundscape(String key, MySoundscape soundscape) async {
  final SharedPreferences historyprefs = await SharedPreferences.getInstance();
  soundscapeName!.add(soundscape.name);
  historyprefs.setStringList(key, soundscapeName!);
}

void onTapPlaylist(String key, MySoundscape soundscape) async {
  final SharedPreferences historyprefs = await SharedPreferences.getInstance();
  playlistName!.add(soundscape.name);
  historyprefs.setStringList(key, playlistName!);
}

void onTapDownload(String key, MySoundscape soundscape) async {
  final SharedPreferences historyprefs = await SharedPreferences.getInstance();
  downloadName!.add(soundscape.name);
  historyprefs.setStringList(key, downloadName!);
}

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
