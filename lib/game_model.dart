import 'package:flutter/foundation.dart';

class GameModel extends ChangeNotifier {
  int _numOfMoves = 0;

  int get numOfMoves => _numOfMoves;

  void addMove() {
    _numOfMoves++;
    notifyListeners();
  }

  void resetNumOfMoves() {
    _numOfMoves = 0;
  }
}
