// grid dimensions
import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color.fromARGB(255, 255, 85, 0),
  Tetromino.J: Color.fromARGB(255, 0, 115, 255),
  Tetromino.I: Color.fromARGB(255, 255, 0, 170),
  Tetromino.O: Color.fromARGB(255, 255, 242, 0),
  Tetromino.S: Color.fromARGB(255, 26, 255, 0),
  Tetromino.Z: Color(0xFFFF0000),
  Tetromino.T: Color.fromARGB(255, 144, 0, 255),
};