import 'package:flutter/material.dart';

class PixelComponent extends StatelessWidget {
  var color;
  bool filled;

  PixelComponent({super.key, required this.color, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.white10, width: 1.0),
        boxShadow: filled
            ? [
                BoxShadow(color: color, blurRadius: 5.0),
                BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15.0,
                    spreadRadius: 5),
              ]
            : [],
      ),
      margin: const EdgeInsets.all(1.0),
    );
  }
}
