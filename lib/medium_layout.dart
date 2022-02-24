import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class MediumLayout extends StatefulWidget {
  const MediumLayout({Key? key}) : super(key: key);

  @override
  State<MediumLayout> createState() => _MediumLayoutState();
}

class _MediumLayoutState extends State<MediumLayout>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
  }

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
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppTitle(),
                  DifficultySelector(
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MovesCounter(isLarge: true),
                  ShuffleButton(onPressed: () async {}),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return GameBoard(
                    animationController: animationController,
                    parentSize: constraints.biggest * 0.8,
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
