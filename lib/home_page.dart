import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    RawKeyboard.instance.addListener(handleKeyDown);
    status = context.read<GameModel>().status;
    final gridSize = context.read<GameModel>().gridSize;
    context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
  }

  @override
  void dispose() {
    difficultyAnimationController.dispose();
    finishAnimationController.dispose();
    RawKeyboard.instance.removeListener(handleKeyDown);
    super.dispose();
  }

  void playFinish() {
    finishAnimationController.forward();
  }

  Future<void> changeDifficulty({
    required Difficulty difficulty,
    required int gridSize,
  }) async {
    final currentDifficulty = context.read<GameModel>().difficulty;
    if (difficulty != currentDifficulty) {
      difficultyAnimationController.forward().whenComplete(() {
        context.read<GameModel>().setDifficulty(difficulty);
        context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
      }).whenComplete(() => difficultyAnimationController.reverse());
    }
  }

  Future<void> start(int gridSize) async {
    context.read<GameModel>().shuffle();
    await context.read<GameBoardModel>().shuffle(gridSize);
    context.read<GameModel>().markPlayable();
    var boxes = context.read<GameBoardModel>().boxes;
    for (var box in boxes) {
      print(box.currentLoc);
    }
  }

  Future<void> handleKeyDown(RawKeyEvent event) async {
    if (event is RawKeyDownEvent) {
      final key = event.physicalKey;
      if (key == PhysicalKeyboardKey.keyS) {
        if (!(status == Status.finished || status == Status.shuffling)) {
          final gridSize = context.read<GameModel>().gridSize;
          start(gridSize);
        }
      } else if (key == PhysicalKeyboardKey.keyP) {
        if (status == Status.finished) {
          context.read<GameModel>().resetGame();
        }
      } else if (key == PhysicalKeyboardKey.keyE) {
        changeDifficulty(difficulty: Difficulty.easy, gridSize: 2);
      } else if (key == PhysicalKeyboardKey.keyN) {
        changeDifficulty(difficulty: Difficulty.normal, gridSize: 3);
      } else if (key == PhysicalKeyboardKey.keyH) {
        changeDifficulty(difficulty: Difficulty.hard, gridSize: 4);
      } else if (key == PhysicalKeyboardKey.digit1) {
        if (status == Status.playable) {
          context.read<GameModel>().useKeyboard = true;
          context.read<GameBoardModel>().selectRowAndColumn(index: 0);
        }
      } else if (key == PhysicalKeyboardKey.digit2) {
        if (status == Status.playable) {
          context.read<GameModel>().useKeyboard = true;
          context.read<GameBoardModel>().selectRowAndColumn(index: 1);
        }
      } else if (key == PhysicalKeyboardKey.digit3) {
        final gridSize = context.read<GameModel>().gridSize;
        if (gridSize > 2) {
          if (status == Status.playable) {
            context.read<GameModel>().useKeyboard = true;
            context.read<GameBoardModel>().selectRowAndColumn(index: 2);
          }
        }
      } else if (key == PhysicalKeyboardKey.digit4) {
        final gridSize = context.read<GameModel>().gridSize;
        if (gridSize > 3) {
          if (status == Status.playable) {
            context.read<GameModel>().useKeyboard = true;
            context.read<GameBoardModel>().selectRowAndColumn(index: 3);
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowLeft) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context.read<GameBoardModel>().moveRowLeft(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowRight) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context.read<GameBoardModel>().moveRowRight(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowUp) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context.read<GameBoardModel>().moveColumnUp(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowDown) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context
              .read<GameBoardModel>()
              .moveColumnDown(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else {
        print(event);
      }
    }
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
