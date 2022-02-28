import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class SmallLayout extends StatefulWidget {
  const SmallLayout({Key? key}) : super(key: key);

  @override
  State<SmallLayout> createState() => _SmallLayoutState();
}

class _SmallLayoutState extends State<SmallLayout>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void playAnimation({
    required Difficulty difficulty,
    required int gridSize,
  }) {
    animationController.forward().whenComplete(() {
      context.read<GameModel>().setDifficulty(difficulty);
      context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
    }).whenComplete(() => animationController.reverse());
  }

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DifficultySelector(
                onEasy: () => playAnimation(
                  gridSize: 2,
                  difficulty: Difficulty.easy,
                ),
                onNormal: () => playAnimation(
                  gridSize: 3,
                  difficulty: Difficulty.normal,
                ),
                onHard: () => playAnimation(
                  gridSize: 4,
                  difficulty: Difficulty.hard,
                ),
              ),
            ),
            const MovesCounter(),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) => GameBoard(
                  animationController: animationController,
                  parentSize: constraints.biggest.shortestSide * 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ShuffleButton(onPressed: () async {
                await context.read<GameBoardModel>().shuffle(gridSize);
              }),
            ),
          ],
        ),
      ],
    );
  }
}
