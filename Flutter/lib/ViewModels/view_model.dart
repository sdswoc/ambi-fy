import 'package:frontend/Models/_Element.dart'; // Assuming you have the Element class defined
import 'package:frontend/Models/_Element_service.dart';

Future<List<MyElement>> fetchElements(String apiUrl) async {
  final elementService = ElementService(apiUrl);
  return await elementService.getElements();
}

List<String> generateElementDetails(List<MyElement> elements) {
  return elements.map((element) {
    return 'Element Name: ${element.name}\nAudio URL: ${element.audio}\nVolume: ${element.volume}';
  }).toList();
}

void main() async {
  const Url = 'http://192.168.43.98';

  // Fetch elements
  final elements = await fetchElements(Url);

  // Generate element details
  final elementDetails = generateElementDetails(elements);

  // Print or use the data as needed
  print('Element Details:');
  for (final detail in elementDetails) {
    print(detail);
  }
}
