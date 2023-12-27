import 'package:frontend/Models/_Element.dart'; // Assuming you have the Element class defined
import 'package:frontend/Models/_Element_service.dart';

Future<List<MyElement>> fetchElements(String apiUrl) async {
  final elementService = ElementService(apiUrl);
  return await elementService.getElements();
}

List<String> generateElementDetails(List<MyElement> elements) {
  return elements.map((element) {
    return 'Element Name: ${element.name}\nAudio URL: ${element.audio}';
  }).toList();
}
