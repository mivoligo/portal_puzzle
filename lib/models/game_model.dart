import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart' as k;

enum Status { initial, shuffling, playable, finished }

enum Difficulty { easy, normal, hard }

class GameModel extends ChangeNotifier {
  Status _status = Status.initial;

  Status get status => _status;

  int _numOfMoves = 0;

  int get numOfMoves => _numOfMoves;

  void addMove({required bool shouldAdd}) {
    if (shouldAdd) {
      _numOfMoves++;
      notifyListeners();
    }
  }

  void _resetNumOfMoves() => _numOfMoves = 0;

  Difficulty _difficulty = Difficulty.normal;

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
      case Difficulty.easy:
        return 2;
      case Difficulty.normal:
        return 3;
      case Difficulty.hard:
        return 4;
    }
  }

  Color get boardColor {
    switch (_difficulty) {
      case Difficulty.easy:
        return k.green;
      case Difficulty.normal:
        return k.darkBlue;
      case Difficulty.hard:
        return k.darkPurple;
    }
  }

  Color get backgroundColor {
    switch (_difficulty) {
      case Difficulty.easy:
        return k.veryLightGreen;
      case Difficulty.normal:
        return k.veryLightBlue;
      case Difficulty.hard:
        return k.veryLightPurple;
    }
  }

  void resetGame() {
    _resetNumOfMoves();
    _status = Status.initial;
    notifyListeners();
  }

  void shuffle() {
    _resetNumOfMoves();
    _status = Status.playable;
    notifyListeners();
  }
}
