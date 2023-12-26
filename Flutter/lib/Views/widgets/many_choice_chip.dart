import 'package:flutter/material.dart';

class ManyChoiceChip extends StatefulWidget {
  const ManyChoiceChip({super.key});

  @override
  State<ManyChoiceChip> createState() => _ManyChoiceChipState();
}

class _ManyChoiceChipState extends State<ManyChoiceChip> {
  final List<String> _playlist = ['All', 'Downloaded', 'Forest', 'a', 'b', 'c'];
  final List<bool> _isselected = [true, false, false, false, false, false];

  void changestat(List<bool> a, bool v, int i) {
    setState(() {
      a[i] = v;
    });
  }

  Widget loopchip(List<bool> v, List<String> a) {
    List<Widget> chips = [];
    for (int i = 0; i < a.length; i++) {
      chips.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChoiceChip(
            label: Text("${a[i]}"),
            selected: v[i],
            selectedColor: Color.fromARGB(255, 149, 121, 121),
            onSelected: (bool val) {
              changestat(v, val, i);
            }),
      ));
    }
    return Row(children: chips);
  }

  @override
  Widget build(BuildContext context) {
    return loopchip(_isselected, _playlist);
  }
}
