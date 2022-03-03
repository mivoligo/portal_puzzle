import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'large_layout.dart';
import 'medium_layout.dart';
import 'models/models.dart';
import 'small_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Status status;
  late final AnimationController difficultyAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final AnimationController finishAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  @override
  void initState() {
    super.initState();
    status = context.read<GameModel>().status;
    final gridSize = context.read<GameModel>().gridSize;
    context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
  }

  @override
  void dispose() {
    difficultyAnimationController.dispose();
    finishAnimationController.dispose();
    super.dispose();
  }

  void playFinish() {
    finishAnimationController.forward();
  }

  Future<void> changeDifficulty({
    required Difficulty difficulty,
    required int gridSize,
  }) async {
    difficultyAnimationController.forward().whenComplete(() {
      context.read<GameModel>().setDifficulty(difficulty);
      context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
    }).whenComplete(() => difficultyAnimationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        context.select<GameModel, Color>((model) => model.backgroundColor);
    status = context.select<GameModel, Status>((model) => model.status);

    if (status == Status.finished) {
      playFinish();
    }
    if (status == Status.initial) {
      finishAnimationController.reset();
    }

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        color: backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layoutWidth = constraints.maxWidth;
            if (layoutWidth < widthSmall) {
              return SmallLayout(
                difficultyAnimation: status == Status.finished
                    ? finishAnimationController
                    : difficultyAnimationController,
                onEasy: () => changeDifficulty(
                  gridSize: 2,
                  difficulty: Difficulty.easy,
                ),
                onNormal: () => changeDifficulty(
                  gridSize: 3,
                  difficulty: Difficulty.normal,
                ),
                onHard: () => changeDifficulty(
                  gridSize: 4,
                  difficulty: Difficulty.hard,
                ),
              );
            } else if (layoutWidth < widthMedium) {
              return MediumLayout(
                difficultyAnimation: status == Status.finished
                    ? finishAnimationController
                    : difficultyAnimationController,
                onEasy: () => changeDifficulty(
                  gridSize: 2,
                  difficulty: Difficulty.easy,
                ),
                onNormal: () => changeDifficulty(
                  gridSize: 3,
                  difficulty: Difficulty.normal,
                ),
                onHard: () => changeDifficulty(
                  gridSize: 4,
                  difficulty: Difficulty.hard,
                ),
              );
            } else {
              return LargeLayout(
                animationController: status == Status.finished
                    ? finishAnimationController
                    : difficultyAnimationController,
                onEasy: () => changeDifficulty(
                  gridSize: 2,
                  difficulty: Difficulty.easy,
                ),
                onNormal: () => changeDifficulty(
                  gridSize: 3,
                  difficulty: Difficulty.normal,
                ),
                onHard: () => changeDifficulty(
                  gridSize: 4,
                  difficulty: Difficulty.hard,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
