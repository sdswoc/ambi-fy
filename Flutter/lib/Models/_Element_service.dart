import 'dart:convert';
import 'package:http/http.dart' as http;
import '_Element.dart';

class ElementService {
  final String baseUrl;

  ElementService(this.baseUrl);

  Future<List<MyElement>> getElements() async {
    final response = await http.get(Uri.parse('$baseUrl/api/elements/'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => MyElement.fromJson(e)).toList();
    } else {
      throw Exception('Unable to load Elements');
    }
  }
}
