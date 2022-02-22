import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart' as k;

enum Difficulty { simple, medium, hard }

class GameModel extends ChangeNotifier {
  int _numOfMoves = 0;

  int get numOfMoves => _numOfMoves;

  void addMove({required bool shouldAdd}) {
    if (shouldAdd) {
      _numOfMoves++;
    }
    notifyListeners();
  }

  void resetNumOfMoves() {
    _numOfMoves = 0;
    notifyListeners();
  }

  Difficulty _difficulty = Difficulty.medium;

  Difficulty get difficulty => _difficulty;

  void setDifficulty(Difficulty difficulty) {
    if (_difficulty != difficulty) {
      _difficulty = difficulty;
      resetGame();
      notifyListeners();
    }
  }

  int get gridSize {
    switch (_difficulty) {
      case Difficulty.simple:
        return 2;
      case Difficulty.medium:
        return 3;
      case Difficulty.hard:
        return 4;
    }
  }

  Color get boardColor {
    switch (_difficulty) {
      case Difficulty.simple:
        return k.green;
      case Difficulty.medium:
        return k.darkBlue;
      case Difficulty.hard:
        return k.darkPurple;
    }
  }

  Color get backgroundColor {
    switch (_difficulty) {
      case Difficulty.simple:
        return k.veryLightGreen;
      case Difficulty.medium:
        return k.veryLightBlue;
      case Difficulty.hard:
        return k.veryLightPurple;
    }
  }

  void resetGame() {
    resetNumOfMoves();
  }
}
