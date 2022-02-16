import 'package:flutter/foundation.dart';

enum Difficulty { simple, medium, hard }

class GameModel extends ChangeNotifier {
  int _numOfMoves = 0;

  int get numOfMoves => _numOfMoves;

  void addMove() {
    _numOfMoves++;
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

  void resetGame() {
    resetNumOfMoves();
  }
}
