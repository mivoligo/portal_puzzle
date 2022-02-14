import 'package:flutter/material.dart';

class GameBox {
  GameBox({
    required this.spawnLoc,
    required this.startLoc,
    required this.currentLoc,
  });

  final Offset spawnLoc;
  Offset startLoc;
  Offset currentLoc;

  bool get isAtSpawn => spawnLoc == currentLoc;

  Rect getRect({required double boardSize, required int gridSize}) {
    final boxWidth = boardSize / gridSize;
    return Rect.fromLTWH(
      currentLoc.dx * boxWidth,
      currentLoc.dy * boxWidth,
      boxWidth,
      boxWidth,
    );
  }
}
