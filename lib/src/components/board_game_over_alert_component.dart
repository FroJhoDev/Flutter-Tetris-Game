import 'package:flutter/material.dart';

class BoardGameOverAlertComponent extends StatelessWidget {

  final int currentScore;
  final Function() playAgainFunction;

  const BoardGameOverAlertComponent({super.key, required this.currentScore, required this.playAgainFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 0, 27, 68),
      shadowColor: const Color.fromARGB(255, 0, 84, 210),
      title: const Text(
        'Game Over',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color.fromARGB(255, 255, 17, 0),
            fontSize: 32.0,
            fontWeight: FontWeight.bold),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'FINAL SCORE',
              style: TextStyle(fontSize: 22.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              '$currentScore',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: playAgainFunction,
          child: Text(
            'Play Again',
            style: TextStyle(
              color: Colors.yellow[600],
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        )
      ],
    );
  }
}
