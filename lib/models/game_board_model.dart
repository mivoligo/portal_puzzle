import 'package:flutter/material.dart';

import 'models.dart';

class GameBoardModel extends ChangeNotifier {
  final List<GameBox> _boxes = [];
  Offset _tappedLoc = Offset.zero;
  final List<GameBox> _tappedRow = [];
  final List<GameBox> _tappedColumn = [];

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

  void setTappedRow({
    required double boardSize,
    required int gridSize,
    required DragStartDetails details,
  }) {
    GameBox? tappedBox;
    _tappedLoc = details.localPosition;
    _tappedRow.clear();
    for (GameBox box in boxes) {
      if (box
          .getRect(boardSize: boardSize, gridSize: gridSize)
          .contains(details.localPosition)) {
        tappedBox = box;
      }
    }
    if (tappedBox != null) {
      for (GameBox rowMateCandidateBox in boxes) {
        if (tappedBox.currentLoc.dy == rowMateCandidateBox.currentLoc.dy) {
          _tappedRow.add(rowMateCandidateBox);
        }
      }
    }
  }

  void setTappedColumn({
    required double boardSize,
    required int gridSize,
    required DragStartDetails details,
  }) {
    GameBox? tappedBox;
    _tappedLoc = details.localPosition;
    _tappedColumn.clear();
    for (GameBox box in boxes) {
      if (box
          .getRect(boardSize: boardSize, gridSize: gridSize)
          .contains(details.localPosition)) {
        tappedBox = box;
      }
    }
    if (tappedBox != null) {
      for (GameBox columnMateCandidateBox in boxes) {
        if (tappedBox.currentLoc.dx == columnMateCandidateBox.currentLoc.dx) {
          _tappedColumn.add(columnMateCandidateBox);
        }
      }
    }
  }

  void moveRow(DragUpdateDetails details, int gridSize, double boardSize) {
    Offset dragOffset = details.localPosition - _tappedLoc;
    double translatedX = dragOffset.dx / boardSize * gridSize;
    for (GameBox box in _tappedRow) {
      box.currentLoc = box.startLoc + Offset(translatedX, 0);
      if (box.currentLoc.dx <= -0.5) {
        box.currentLoc = Offset(
          box.startLoc.dx + gridSize + translatedX,
          box.currentLoc.dy,
        );
      }
      if (box.currentLoc.dx > gridSize - 0.5) {
        box.currentLoc = Offset(
          box.startLoc.dx - gridSize + translatedX,
          box.currentLoc.dy,
        );
      }
    }
    notifyListeners();
  }

  void moveColumn(DragUpdateDetails details, int gridSize, double boardSize) {
    Offset dragOffset = details.localPosition - _tappedLoc;
    double translatedY = dragOffset.dy / boardSize * gridSize;
    for (GameBox box in _tappedColumn) {
      box.currentLoc = box.startLoc + Offset(0, translatedY);
      if (box.currentLoc.dy <= -0.5) {
        box.currentLoc = Offset(
          box.currentLoc.dx,
          box.startLoc.dy + gridSize + translatedY,
        );
      }
      if (box.currentLoc.dy > gridSize - 0.5) {
        box.currentLoc = Offset(
          box.currentLoc.dx,
          box.startLoc.dy - gridSize + translatedY,
        );
      }
    }
    notifyListeners();
  }
}
