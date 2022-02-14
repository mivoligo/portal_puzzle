import 'package:flutter/material.dart';

class GameBoxModel {
  GameBoxModel({
    required this.originalLocation,
    required this.startLocation,
    required this.currentLocation,
  });

  final Offset originalLocation;
  Offset startLocation;
  Offset currentLocation;

  Rect getRect({required double boardSize, required int gridSize}) {
    final totalBoxWidth = boardSize / gridSize;
    return Rect.fromLTWH(
      currentLocation.dx * totalBoxWidth,
      currentLocation.dy * totalBoxWidth,
      totalBoxWidth,
      totalBoxWidth,
    );
  }
}
