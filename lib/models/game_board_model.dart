import 'package:flutter/material.dart';

import 'models.dart';

class GameBoardModel extends ChangeNotifier {
  final List<GameBox> _boxes = [];

  List<GameBox> get boxes => _boxes;

  void generateGameBoxes({required int gridSize}) {
    _boxes.clear();
    for (double y = 0; y < gridSize; y++) {
      for (double x = 0; x < gridSize; x++) {
        _boxes.add(
          GameBox(
            spawnLoc: Offset(x, y),
            startLoc: Offset(x, y),
            currentLoc: Offset(x, y),
          ),
        );
      }
    }
  }

  void snapBoxes() {
    for (GameBox box in boxes) {
      Offset translatedLoc = box.currentLoc + const Offset(1, 1);
      box.currentLoc = Offset(
        translatedLoc.dx.round() - 1,
        translatedLoc.dy.round() - 1,
      );
    }
  }

  void updateBoxesLocation() {
    for (final box in _boxes) {
      box.startLoc = box.currentLoc;
    }
  }

  GameBox? getTappedBox({
    required double boardSize,
    required Offset globalCoords,
    required int gridSize,
  }) {
    for (GameBox box in boxes) {
      if (box
          .getRect(boardSize: boardSize, gridSize: gridSize)
          .contains(globalCoords)) {
        return box;
      }
    }
    return null;
  }

  List<GameBox> getRowMatesForBox(GameBox box) {
    final rowMates = <GameBox>[];
    for (GameBox rowMateCandidateBox in boxes) {
      if (box.currentLoc.dy == rowMateCandidateBox.currentLoc.dy) {
        rowMates.add(rowMateCandidateBox);
      }
    }
    return rowMates;
  }

  List<GameBox> getColumnMatesForBox(GameBox box) {
    final columnMates = <GameBox>[];
    for (GameBox columnMateCandidateBox in boxes) {
      if (box.currentLoc.dx == columnMateCandidateBox.currentLoc.dx) {
        columnMates.add(columnMateCandidateBox);
      }
    }
    return columnMates;
  }
}
