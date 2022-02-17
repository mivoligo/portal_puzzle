import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class GameBoxTile extends StatelessWidget {
  const GameBoxTile({
    Key? key,
    required this.box,
    required this.text,
    required this.boardSize,
  }) : super(key: key);

  final GameBox box;
  final String text;
  final double boardSize;

  @override
  Widget build(BuildContext context) {
    final gridSize = context.watch<GameModel>().gridSize;
    final gameBoxRect = box.getRect(boardSize: boardSize, gridSize: gridSize);
    return Positioned(
      left: gameBoxRect.left,
      top: gameBoxRect.top,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        curve: Curves.decelerate,
        scale: box.currentLoc.dx < -0.1 ||
                box.currentLoc.dx > gridSize - 0.9 ||
                box.currentLoc.dy < -0.1 ||
                box.currentLoc.dy > gridSize - 0.9
            ? 0.8
            : 1,
        child: Container(
          width: gameBoxRect.width,
          height: gameBoxRect.height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: box.isAtSpawn ? Colors.orange : Colors.blueGrey,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
                fontSize: gameBoxRect.height * 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
