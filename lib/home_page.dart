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
  }

  Future<void> handleKeyDown(RawKeyEvent event) async {
    if (event is RawKeyDownEvent) {
      final key = event.physicalKey;
      if (key == PhysicalKeyboardKey.keyP || key == PhysicalKeyboardKey.enter) {
        if (!(status == Status.finished || status == Status.shuffling)) {
          final gridSize = context.read<GameModel>().gridSize;
          start(gridSize);
        } else if (status == Status.finished) {
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
      } else if (key == PhysicalKeyboardKey.arrowLeft ||
          key == PhysicalKeyboardKey.keyA) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context.read<GameBoardModel>().moveRowLeft(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowRight ||
          key == PhysicalKeyboardKey.keyD) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context.read<GameBoardModel>().moveRowRight(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowUp ||
          key == PhysicalKeyboardKey.keyW) {
        if (status == Status.playable &&
            context.read<GameModel>().useKeyboard) {
          final gridSize = context.read<GameModel>().gridSize;
          await context.read<GameBoardModel>().moveColumnUp(gridSize: gridSize);
          context.read<GameModel>().addMove(shouldAdd: true);
          if (context.read<GameBoardModel>().puzzleSolved) {
            context.read<GameModel>().markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowDown ||
          key == PhysicalKeyboardKey.keyS) {
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
      } else if (key == PhysicalKeyboardKey.space ||
          key == PhysicalKeyboardKey.f1) {
        showDialog(
            context: context,
            builder: (context) {
              return const ShortcutsDialog();
            });
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

class ShortcutsDialog extends StatelessWidget {
  const ShortcutsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      title: Center(child: Text('Keyboard shortcuts')),
      contentPadding: EdgeInsets.all(16),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Difficulty selection'),
        ),
        _Shortcut(shortcut: 'E', label: 'Easy'),
        _Shortcut(shortcut: 'N', label: 'Normal'),
        _Shortcut(shortcut: 'H', label: 'Hard'),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Gameplay'),
        ),
        _Shortcut(shortcut: 'P', altShortcut: '↵', label: 'Play (Shuffle)'),
        SizedBox(height: 12),
        _Shortcut(shortcut: '1', label: 'Select first row, column'),
        _Shortcut(shortcut: '2', label: 'Select second row, column'),
        _Shortcut(shortcut: '3', label: 'Select third row, column'),
        _Shortcut(shortcut: '4', label: 'Select fourth row, column'),
        SizedBox(height: 12),
        _Shortcut(
            shortcut: '↑', altShortcut: 'W', label: 'Move selected column up'),
        _Shortcut(
            shortcut: '↓',
            altShortcut: 'S',
            label: 'Move selected column down'),
        _Shortcut(
            shortcut: '←', altShortcut: 'A', label: 'Move selected row left'),
        _Shortcut(
            shortcut: '→', altShortcut: 'D', label: 'Move selected row right'),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('General'),
        ),
        _Shortcut(
            shortcut: 'F1',
            altShortcut: 'Space',
            label: 'Show this window again'),
        _Shortcut(shortcut: 'Esc', label: 'Close this window'),
      ],
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    Key? key,
    required this.shortcut,
    this.altShortcut,
    required this.label,
  }) : super(key: key);

  final String shortcut;
  final String? altShortcut;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              child: Text(
                shortcut,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: darkViolet, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        if (altShortcut != null) const Text('or'),
        if (altShortcut != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Center(
                child: Text(
                  altShortcut!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: darkViolet, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
        Text(label),
      ],
    );
  }
}
