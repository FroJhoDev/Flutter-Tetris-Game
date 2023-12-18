import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BoardGameControlsComponent extends StatelessWidget {

  final Function() moveLeft;
  final Function() moveRight;
  final Function() rotatePiece;

  const BoardGameControlsComponent({super.key, required this.moveLeft, required this.moveRight, required this.rotatePiece});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // left
          IconButton(
            onPressed: () => moveLeft(),
            color: Colors.yellow[600],
            icon: Icon(
              MdiIcons.arrowLeftBoldBox,
              size: 70.0,
            ),
          ),

          // rotate
          IconButton(
            onPressed: () => rotatePiece(),
            color: Colors.yellow[200],
            icon: Icon(
              MdiIcons.rotateRight,
              size: 50.0,
            ),
          ),

          // right
          IconButton(
            onPressed: () => moveRight(),
            color: Colors.yellow[600],
            icon: Icon(
              MdiIcons.arrowRightBoldBox,
              size: 70.0,
            ),
          ),
        ],
      ),
    );
  }
}
