import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/Models/_Soundscape.dart';
import 'package:frontend/Models/_Soundscape_service.dart';

final String djangoURL = dotenv.env['LOCALHOST_URL']!;

class SoundGeneratorViewModel {
  late SoundscapeService _soundscapeService;
  late List<MySoundscape> _soundscapes;

  SoundGeneratorViewModel() {
    _soundscapeService = SoundscapeService(djangoURL);
    _soundscapes = [];
  }

  Future<List<MySoundscape>> loadSoundscapes() async {
    _soundscapes = await _soundscapeService.getSoundscapes();
    return _soundscapes;
  }

  List<MySoundscape> get soundscapes => _soundscapes;
}
