import 'package:flutter/material.dart';

import 'models.dart';

class GameBoardModel extends ChangeNotifier {
  final List<GameBoxModel> _boxes = [];

  List<GameBoxModel> get boxes => _boxes;

  void generateGameBoxes({required int gridSize}) {
    _boxes.clear();
    for (double y = 0; y < gridSize; y++) {
      for (double x = 0; x < gridSize; x++) {
        _boxes.add(
          GameBoxModel(
            originalLocation: Offset(x, y),
            startLocation: Offset(x, y),
            currentLocation: Offset(x, y),
          ),
        );
      }
    }
  }

  void snapBoxes() {
    for (GameBoxModel box in boxes) {
      Offset translatedLoc = box.currentLocation + const Offset(1, 1);
      box.currentLocation = Offset(
        translatedLoc.dx.round() - 1,
        translatedLoc.dy.round() - 1,
      );
    }
  }

  void updateGameBoxesLocation() {
    for (final box in _boxes) {
      box.startLocation = box.currentLocation;
    }
  }

  GameBoxModel? getTappedBox({
    required Size parentSize,
    required Offset globalCoords,
    required int gridSize,
  }) {
    for (GameBoxModel box in boxes) {
      if (box
          .getRect(parentSize: parentSize, gridSize: gridSize)
          .contains(globalCoords)) {
        return box;
      }
    }
    return null;
  }

  List<GameBoxModel> getRowMatesForBox(GameBoxModel box) {
    final rowMates = <GameBoxModel>[];
    for (GameBoxModel rowMateCandidateBox in boxes) {
      if (box.currentLocation.dy == rowMateCandidateBox.currentLocation.dy) {
        rowMates.add(rowMateCandidateBox);
      }
    }
    return rowMates;
  }

  List<GameBoxModel> getColumnMatesForBox(GameBoxModel box) {
    final columnMates = <GameBoxModel>[];
    for (GameBoxModel columnMateCandidateBox in boxes) {
      if (box.currentLocation.dx == columnMateCandidateBox.currentLocation.dx) {
        columnMates.add(columnMateCandidateBox);
      }
    }
    return columnMates;
  }
}
