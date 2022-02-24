import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class LargeLayout extends StatefulWidget {
  const LargeLayout({Key? key}) : super(key: key);

  @override
  State<LargeLayout> createState() => _LargeLayoutState();
}

class _LargeLayoutState extends State<LargeLayout>
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
    final difficulty = context.select<GameModel, Difficulty>(
      (model) => model.difficulty,
    );

    String difficultyString;

    switch (difficulty) {
      case Difficulty.easy:
        difficultyString = 'Easy';
        break;
      case Difficulty.normal:
        difficultyString = 'Normal';
        break;
      case Difficulty.hard:
        difficultyString = 'Hard';
        break;
    }

    return Stack(
      children: [
        Positioned(
          top: 64,
          right: 64,
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 250,
                    child: AppTitle(isLarge: true),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Difficulty: $difficultyString',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  const MovesCounter(
                    isLarge: true,
                  ),
                  const SizedBox(height: 24),
                  ShuffleButton(
                    onPressed: () async {},
                  ),
                ],
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GameBoard(
              animationController: animationController,
              parentSize: constraints.biggest * 0.6,
            );
          },
        ),
      ],
    );
  }
}
