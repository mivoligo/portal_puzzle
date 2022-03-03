import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'large_layout.dart';
import 'medium_layout.dart';
import 'models/models.dart';
import 'result_page.dart';
import 'small_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
    final gridSize = context.read<GameModel>().gridSize;
    context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> playAnimation({
    required Difficulty difficulty,
    required int gridSize,
  }) async {
    animationController.forward().whenComplete(() {
      context.read<GameModel>().setDifficulty(difficulty);
      context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
    }).whenComplete(() => animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        context.select<GameModel, Color>((model) => model.backgroundColor);
    final status = context.select<GameModel, Status>((model) => model.status);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: status == Status.finished
          ? const ResultPage()
          : Scaffold(
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                color: backgroundColor,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final layoutWidth = constraints.maxWidth;
                    if (layoutWidth < widthSmall) {
                      return SmallLayout(
                        difficultyAnimation: animationController,
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
                      );
                    } else if (layoutWidth < widthMedium) {
                      return MediumLayout(
                        difficultyAnimation: animationController,
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
                      );
                    } else {
                      return LargeLayout(
                        difficultyAnimation: animationController,
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
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }
}
