import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:frontend/Models/_Element.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:path_provider/path_provider.dart';

class AudioDownloader {
  final Dio _dio = Dio();

  Future<void> downloadAndSaveAudio(
      String filepath, String audioUrl, String fileName) async {
    try {
      await _dio.download(audioUrl, filepath);
    } catch (e) {
      print('Error downloading audio: $e');
    }
  }
}

class DownloadedSoundscape {
  late List<AudioPlayer> _audioPlayer;
  final AudioDownloader _audioDownloader = AudioDownloader();

  Future<void> _saveToFile(
      String filePath, Map<String, dynamic> jsonData) async {
    print(filePath);
    print(jsonData);

    try {
      final File file = File(filePath);
      try {
        await file.writeAsString(jsonEncode(jsonData));
      } catch (e) {
        print('Error writing file: $e');
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  Future<void> saveSoundscape(MySoundscape mySoundscape) async {
    try {
      final soundscapeDir = await _getSoundscapeDir(mySoundscape.name);
      final String soundscapePath = soundscapeDir.path;
      print('AAAAAAAA ' + soundscapePath);
      await _saveToFileString(soundscapePath + "/soundscape.json", 'AKSHIT');

      for (var i = 0; i < mySoundscape.elements.length; i++) {
        final element = mySoundscape.elements[i];
        final elementPath = '$soundscapePath/${element.name}';

        await _audioDownloader.downloadAndSaveAudio(
          elementPath,
          element.audio,
          '${element.name}.mp3',
        );

        await _saveToFile(
            '$soundscapePath/${element.name}/element.json', element.toJson());
      }
    } catch (e) {
      print('Error saving soundscape: $e');
    }
  }

  Future<MySoundscape?> loadSoundscape(String soundscapeName) async {
    try {
      final soundscapeDir = await _getSoundscapeDir(soundscapeName);
      final String soundscapePath = soundscapeDir.path;

      final Map<String, dynamic> soundscapeData =
          await _loadFromFile('$soundscapePath/soundscape.json');
      final MySoundscape loadedSoundscape =
          MySoundscape.fromJson(soundscapeData);

      for (int i = 0; i < loadedSoundscape.elements.length; i++) {
        final elementPath =
            '$soundscapePath/${loadedSoundscape.elements[i].name}';

        final Map<String, dynamic> elementData =
            await _loadFromFile('$elementPath/element.json');
        loadedSoundscape.elements[i] = MyElement.fromJson(elementData);

        _audioPlayer[i] = AudioPlayer();
        _audioPlayer[i].play(DeviceFileSource(
            '$elementPath/${loadedSoundscape.elements[i].name}.mp3'));
      }

      return loadedSoundscape;
    } catch (e) {
      print('Error loading soundscape: $e');
      return null;
    }
  }

  Future<void> _saveToFileString(String filePath, String jsonData) async {
    print(filePath);
    print(jsonData);

    try {
      // awaitDirectory(filePath).create(recursive: true);
      final File file = File(filePath);

      print(file.statSync().mode);
      try {
        await file.writeAsString((jsonData));
      } catch (e) {
        print('Error writing file: $e');
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  Future<Map<String, dynamic>> _loadFromFile(String filePath) async {
    final File file = File(filePath);
    final String jsonString = await file.readAsString();
    return jsonDecode(jsonString);
  }

  Future<Directory> _getSoundscapeDir(String soundscapeName) async {
    // final appDir = await getDownloadsDirectory();
    // print(appDir!.path);
    // //final sanitizedSoundscapeName = soundscapeName.replaceAll(' ', '_');
    final appDir = await getTemporaryDirectory();
    final checkPathExistence = await Directory(appDir!.path).exists();
    print(checkPathExistence);
    return Directory('${appDir}');
  }
}
