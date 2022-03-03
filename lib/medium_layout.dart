import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class MediumLayout extends StatelessWidget {
  const MediumLayout({
    Key? key,
    required this.difficultyAnimation,
    required this.onEasy,
    required this.onNormal,
    required this.onHard,
  }) : super(key: key);

  final AnimationController difficultyAnimation;
  final VoidCallback onEasy;
  final VoidCallback onNormal;
  final VoidCallback onHard;

  @override
  Widget build(BuildContext context) {
    final gridSize = context.select<GameModel, int>((model) => model.gridSize);
    final status = context.select<GameModel, Status>((model) => model.status);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (status == Status.initial)
          const Positioned(top: 124, right: 80, child: Bubbles()),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppTitle(),
                  DifficultySelector(
                    onEasy: onEasy,
                    onNormal: onNormal,
                    onHard: onHard,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MovesCounter(isLarge: true),
                  ShuffleButton(onPressed: () async {
                    await context.read<GameBoardModel>().shuffle(gridSize);
                  }),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return GameBoard(
                    animationController: difficultyAnimation,
                    parentSize: constraints.biggest.shortestSide * 0.8,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
