import 'dart:math';

import 'package:flutter/material.dart';

import 'models.dart';

class GameBoardModel extends ChangeNotifier {
  final _random = Random();
  final List<GameBox> _boxes = [];
  Offset _tappedLoc = Offset.zero;
  final List<GameBox> _tappedRow = [];
  final List<GameBox> _tappedColumn = [];

  List<GameBox> get boxes => _boxes;

  bool get puzzleSolved => !_boxes.any((box) => !box.isAtSpawn);

  bool boxesChanged = false;

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
    boxesChanged = false;
    for (final box in _boxes) {
      if (box.startLoc != box.currentLoc) {
        box.startLoc = box.currentLoc;
        boxesChanged = true;
      }
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

  void dragRow(DragUpdateDetails details, int gridSize, double boardSize) {
    Offset dragOffset = details.localPosition - _tappedLoc;
    double translatedX = dragOffset.dx / boardSize * gridSize;

    if (details.localPosition.dx >= 0 &&
        details.localPosition.dx <= boardSize) {
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
  }

  void dragColumn(DragUpdateDetails details, int gridSize, double boardSize) {
    Offset dragOffset = details.localPosition - _tappedLoc;
    double translatedY = dragOffset.dy / boardSize * gridSize;
    if (details.localPosition.dy >= 0 &&
        details.localPosition.dy <= boardSize) {
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

  Future<void> _moveRow({
    required double rowIndex,
    required int gridSize,
  }) async {
    _tappedRow.clear();
    for (final box in _boxes) {
      if (box.currentLoc.dy == rowIndex) {
        _tappedRow.add(box);
      }
    }
    await Future.delayed(const Duration(milliseconds: 60));
    for (final box in _tappedRow) {
      box.currentLoc = Offset(box.currentLoc.dx - 0.5, rowIndex);
      if (box.currentLoc.dx <= -0.5) {
        box.currentLoc = Offset(gridSize - 0.5, rowIndex);
      }
    }
    await Future.delayed(const Duration(milliseconds: 60));
    for (final box in _tappedRow) {
      box.currentLoc = Offset(box.currentLoc.dx - 0.5, rowIndex);
      if (box.currentLoc.dx <= -0.5) {
        box.currentLoc = Offset(gridSize - 0.5, rowIndex);
      }
    }
    await Future.delayed(const Duration(milliseconds: 60));

    updateBoxesLocation();

    notifyListeners();
  }

  Future<void> _moveColumn({
    required double columnIndex,
    required int gridSize,
  }) async {
    _tappedColumn.clear();
    for (final box in _boxes) {
      if (box.currentLoc.dx == columnIndex) {
        _tappedColumn.add(box);
      }
    }
    await Future.delayed(const Duration(milliseconds: 60));
    for (final box in _tappedColumn) {
      box.currentLoc = Offset(columnIndex, box.currentLoc.dy - 0.5);
      if (box.currentLoc.dy <= -0.5) {
        box.currentLoc = Offset(columnIndex, gridSize - 0.5);
      }
    }
    await Future.delayed(const Duration(milliseconds: 60));
    for (final box in _tappedColumn) {
      box.currentLoc = Offset(columnIndex, box.currentLoc.dy - 0.5);
      if (box.currentLoc.dy <= -0.5) {
        box.currentLoc = Offset(columnIndex, gridSize - 0.5);
      }
    }
    await Future.delayed(const Duration(milliseconds: 60));

    updateBoxesLocation();

    notifyListeners();
  }

  Future<void> shuffle(int gridSize) async {
    do {
      for (var i = 0; i <= gridSize; i++) {
        final randomRow = _random.nextInt(gridSize).toDouble();
        final randomColumn = _random.nextInt(gridSize).toDouble();

        await _moveRow(rowIndex: randomRow, gridSize: gridSize);
        await _moveColumn(columnIndex: randomColumn, gridSize: gridSize);
        await Future.delayed(const Duration(milliseconds: 60));
      }
    } while (puzzleSolved); // prevent shuffling to the solution :)
  }
}
