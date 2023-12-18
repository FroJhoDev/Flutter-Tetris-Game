import 'package:flutter/material.dart';

class BoardBackgroundComponent extends StatelessWidget {
  const BoardBackgroundComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 0, 42, 104),
            Color.fromARGB(255, 0, 27, 68),
          ])),
    );
  }
}
