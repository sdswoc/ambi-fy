import 'package:frontend/Models/_Element.dart';

class MySoundscape {
  late String name;
  late List<MyElement> elements;

  MySoundscape({required this.name, required this.elements});

  factory MySoundscape.fromJson(Map<String, dynamic> data) {
    return MySoundscape(
        name: data['name'],
        elements: List<MyElement>.from((data['elements'] as List)
            .map((elementData) => MyElement.fromJson(elementData))));
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'elements': elements};
  }
}
