import 'dart:async';
import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../components/pixel_component.dart';
import '../models/piece_model.dart';
import '../utils/values.dart';

/*

  GAME BOARD

  This is as 2x2 grid with null representing an empty space.
  A nun empty space will have the color to represent the landad piaces

*/

// create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // initial tetris piece
  PieceModel currentPiece = PieceModel(type: Tetromino.J);

  // initial score
  int currentScore = 0;

  // gameover status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        // clear line
        clearLines();

        // check landing
        checkLanding();

        // check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }

        // move piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // game over message
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () {
              // reset the game
              resetGame();

              Navigator.pop(context);
            },
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
      ),
    );
  }

  // void showGameOverDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Game Over'),
  //       content: Text('Your score is: $currentScore'),
  //       actions: [
  //         TextButton(
  //             onPressed: () {
  //               // reset the game
  //               resetGame();

  //               Navigator.pop(context);
  //             },
  //             child: const Text('Play Again'))
  //       ],
  //     ),
  //   );
  // }

  // reset the game
  void resetGame() {
    // clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    // new game
    gameOver = false;
    currentScore = 0;

    // create new piece
    createNewPiece();

    // start game again
    startGame();
  }

  // check for collision in a future position
  // return -> true there is a collision
  // return -> false there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      // check if the current position is already occupied by another piece in the game board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    // if no collisions are detected, return false
    return false;
  }

  void checkLanding() {
    // if going down is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a radom object to generate random tetromino types
    Random rand = Random();

    // create a new piece with a random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = PieceModel(type: randomType);
    currentPiece.initializePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  // Move left
  void moveLeft() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // Move right
  void moveRight() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // Rotate Piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // clear lines
  void clearLines() {
    // step 1: Loop throung each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: Check if the row if full (all columns in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        // if there's an empty colunm, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: if the row is full, clear the row and shift row down
      if (rowIsFull) {
        // step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          // copy the above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        // step 7: Increase the score
        currentScore += 100;
      }
    }
  }

  // GEME OVER METHOD
  bool isGameOver() {
    // check if any colunms in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    // if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 27, 68),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(255, 0, 42, 104),
                  Color.fromARGB(255, 0, 27, 68),
                ])),
          ),
          Column(
            children: [
              // SCORE
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score:'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18.0),
                      ),
                      const SizedBox(width: 3.0),
                      AnimatedFlipCounter(
                        curve: Curves.bounceInOut,
                        duration: const Duration(milliseconds: 500),
                        value: currentScore,
                        textStyle: TextStyle(
                            color: Colors.yellow[200], fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),

              // GEME BOARD
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rowLength * colLength,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength,
                  ),
                  itemBuilder: (context, index) {
                    // get row and col of each index
                    int row = (index / rowLength).floor();
                    int col = index % rowLength;

                    // current piece
                    if (currentPiece.position.contains(index)) {
                      return PixelComponent(
                        color: currentPiece.color,
                        filled: true,
                      );

                      // land pieces
                    } else if (gameBoard[row][col] != null) {
                      final Tetromino? tetrominoType = gameBoard[row][col];
                      return PixelComponent(
                        color: tetrominoColors[tetrominoType],
                        filled: true,
                      );

                      // blank pixel
                    } else {
                      return PixelComponent(
                        color: Colors.transparent,
                        filled: false,
                      );
                    }
                  },
                ),
              ),

              // GAME CONTROLS
              Padding(
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
