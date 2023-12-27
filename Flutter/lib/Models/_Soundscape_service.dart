import 'dart:convert';
import 'package:http/http.dart' as http;
import '_Soundscape.dart';

class SoundscapeService {
  final String baseUrl;

  SoundscapeService(this.baseUrl);

  Future<List<MySoundscape>> getSoundscapes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/soundscapes/'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => MySoundscape.fromJson(e)).toList();
    } else {
      throw Exception('Unable to load Soundscapes');
    }
  }
}
