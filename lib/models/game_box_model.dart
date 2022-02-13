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

  Rect getRect({required Size parentSize, required int gridSize}) {
    final totalBoxWidth = parentSize.shortestSide / gridSize;
    return Rect.fromLTWH(
      currentLocation.dx * totalBoxWidth,
      currentLocation.dy * totalBoxWidth,
      totalBoxWidth,
      totalBoxWidth,
    );
  }
}
