import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class SmallLayout extends StatelessWidget {
  const SmallLayout({
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
          const Positioned(bottom: 64, child: Bubbles()),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: AppTitle(),
            ),
            if (status != Status.finished)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DifficultySelector(
                  onEasy: onEasy,
                  onNormal: onNormal,
                  onHard: onHard,
                ),
              ),
            (status != Status.finished)
                ? const MovesCounter()
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SolvedMessage(),
                  ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) => GameBoard(
                  animationController: difficultyAnimation,
                  parentSize: constraints.biggest.shortestSide * 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: StartButton(onPressed: () async {
                await context.read<GameBoardModel>().shuffle(gridSize);
              }),
            ),
          ],
        ),
        const Positioned(
          right: 24,
          bottom: 32,
          child: InfoButton(),
        )
      ],
    );
  }
}
