import 'package:flutter/material.dart';
import 'package:frontend/Models/_Element_service.dart';
import 'package:frontend/Models/_Element.dart';

class SoundGenerator extends StatefulWidget {
  const SoundGenerator({super.key});

  @override
  State<SoundGenerator> createState() => _SoundGeneratorState();
}

class _SoundGeneratorState extends State<SoundGenerator> {
  List<Widget> generators = [];
  late ElementService _elementService;
  late Future<List<MyElement>> _elements;

  Widget ManySoundGenerator(List<MyElement> _elements) {
    for (int i = 0; i < _elements.length; i++) {
      generators.add(GestureDetector(
        onTap: null,
        onLongPress: null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.grey[600],
                backgroundBlendMode: BlendMode.luminosity,
                borderRadius: BorderRadius.circular(13)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
              child: SizedBox(
                child: Text(_elements[i].name,
                    style: const TextStyle(
                        color: Colors.white, // Set the text color
                        fontSize: 24, // Set the font size
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto')),
              ),
            ),
          ),
        ),
      ));
    }
    return ListView(children: generators);
  }

  @override
  void initState() {
    super.initState();
    _elementService = ElementService('http://10.0.2.2:8000');
    _elements = _elementService.getElements();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MyElement>>(
        future: _elements,
        builder: (context, snapshot) {
          print("Connection State: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No elements found');
          } else {
            return ManySoundGenerator(snapshot.data!);
          }
          ;
        });
  }
}
