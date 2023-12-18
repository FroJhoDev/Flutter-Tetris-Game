import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class BoardScoreComponent extends StatelessWidget {

  final int currentScore;

  const BoardScoreComponent({super.key, required this.currentScore});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score:'.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            const SizedBox(width: 3.0),
            AnimatedFlipCounter(
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 500),
              value: currentScore,
              textStyle: TextStyle(color: Colors.yellow[200], fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
