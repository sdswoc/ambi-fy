import 'package:flutter/material.dart';

class BottomSheetOptions extends StatelessWidget {
  final String message;
  final IconButton? iconbutton1;
  final IconButton? iconbutton2;
  final Icon? icon;
  const BottomSheetOptions(
      {super.key,
      required this.message,
      this.iconbutton1,
      this.iconbutton2,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.grey.shade800,
          height: 100,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: iconbutton1,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: icon,
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: iconbutton2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
