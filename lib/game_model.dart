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

  Difficulty _difficulty = Difficulty.simple;

  Difficulty get difficulty => _difficulty;

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    resetGame();
    notifyListeners();
  }

  void resetGame() {
    resetNumOfMoves();
  }
}
