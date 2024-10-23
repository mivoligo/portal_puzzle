import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';

class GameBoxTile extends StatelessWidget {
  const GameBoxTile({
    super.key,
    required this.box,
    required this.text,
    required this.boardSize,
  });

  final GameBox box;
  final String text;
  final double boardSize;

  @override
  Widget build(BuildContext context) {
    final useKeyboard = context.watch<GameModel>().useKeyboard;
    final gridSize = context.watch<GameModel>().gridSize;
    final tappedRow = context.watch<GameBoardModel>().tappedRow;
    final tappedColumn = context.watch<GameBoardModel>().tappedColumn;
    final gameBoxRect = box.getRect(boardSize: boardSize, gridSize: gridSize);
    return AnimatedScale(
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
          borderRadius: BorderRadius.all(Radius.circular(boardSize * 0.01)),
          color: useKeyboard &&
                  (tappedRow.contains(box) || tappedColumn.contains(box))
              ? lightRose.withOpacity(0.5)
              : const Color(0xAA94A3B8),
          border: Border.all(color: const Color(0xAACBD5E1)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: box.isAtSpawn
                  ? const Color(0xFFF1F5F9)
                  : const Color(0xFFCBD5E1),
              shadows: const [
                Shadow(
                  color: Color(0x44222222),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                )
              ],
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w600,
              fontSize: gameBoxRect.height * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
