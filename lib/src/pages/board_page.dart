import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/values.dart';
import '../models/piece_model.dart';

import '../components/pixel_component.dart';
import '../components/board_score_component.dart';
import '../components/board_background_component.dart';
import '../components/board_game_controls_component.dart';
import '../components/board_game_over_alert_component.dart';

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
      builder: (context) => BoardGameOverAlertComponent(
        currentScore: currentScore,
        playAgainFunction: () {
          // reset the game
          resetGame();
          Navigator.pop(context);
        },
      ),
    );
  }

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
          const BoardBackgroundComponent(),
          Column(
            children: [
              BoardScoreComponent(currentScore: currentScore),

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

              BoardGameControlsComponent(
                moveLeft: moveLeft,
                moveRight: moveRight,
                rotatePiece: rotatePiece,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
