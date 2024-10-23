import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'large_layout.dart';
import 'medium_layout.dart';
import 'models/models.dart';
import 'small_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  bool visibleShortcuts = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(handleKeyPress);
    status = context.read<GameModel>().status;
    final gridSize = context.read<GameModel>().gridSize;
    context.read<GameBoardModel>().generateGameBoxes(gridSize: gridSize);
  }

  @override
  void dispose() {
    difficultyAnimationController.dispose();
    finishAnimationController.dispose();
    HardwareKeyboard.instance.removeHandler(handleKeyPress);
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
    final gameModel = context.read<GameModel>();

    gameModel.shuffle();
    await context.read<GameBoardModel>().shuffle(gridSize);
    gameModel.markPlayable();
  }

  bool handleKeyPress(KeyEvent event) {
    final key = event.physicalKey;
    final gameModel = context.read<GameModel>();
    final gameBoardModel = context.read<GameBoardModel>();

    if (event is KeyUpEvent) {
      if (key == PhysicalKeyboardKey.keyP || key == PhysicalKeyboardKey.enter) {
        if (!(status == Status.finished || status == Status.shuffling)) {
          final gridSize = gameModel.gridSize;
          start(gridSize);
        } else if (status == Status.finished) {
          gameModel.resetGame();
        }
      } else if (key == PhysicalKeyboardKey.keyE) {
        changeDifficulty(difficulty: Difficulty.easy, gridSize: 2);
      } else if (key == PhysicalKeyboardKey.keyN) {
        changeDifficulty(difficulty: Difficulty.normal, gridSize: 3);
      } else if (key == PhysicalKeyboardKey.keyH) {
        changeDifficulty(difficulty: Difficulty.hard, gridSize: 4);
      } else if (key == PhysicalKeyboardKey.digit1) {
        if (status == Status.playable) {
          gameModel.useKeyboard = true;
          gameBoardModel.selectRowAndColumn(index: 0);
        }
      } else if (key == PhysicalKeyboardKey.digit2) {
        if (status == Status.playable) {
          gameModel.useKeyboard = true;
          gameBoardModel.selectRowAndColumn(index: 1);
        }
      } else if (key == PhysicalKeyboardKey.digit3) {
        final gridSize = gameModel.gridSize;
        if (gridSize > 2) {
          if (status == Status.playable) {
            gameModel.useKeyboard = true;
            gameBoardModel.selectRowAndColumn(index: 2);
          }
        }
      } else if (key == PhysicalKeyboardKey.digit4) {
        final gridSize = gameModel.gridSize;
        if (gridSize > 3) {
          if (status == Status.playable) {
            gameModel.useKeyboard = true;
            gameBoardModel.selectRowAndColumn(index: 3);
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowLeft ||
          key == PhysicalKeyboardKey.keyA) {
        if (status == Status.playable && gameModel.useKeyboard) {
          final gridSize = gameModel.gridSize;
          gameBoardModel.moveRowLeft(gridSize: gridSize);
          gameModel.addMove(shouldAdd: true);
          if (gameBoardModel.puzzleSolved) {
            gameModel.markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowRight ||
          key == PhysicalKeyboardKey.keyD) {
        if (status == Status.playable && gameModel.useKeyboard) {
          final gridSize = gameModel.gridSize;
          gameBoardModel.moveRowRight(gridSize: gridSize);
          gameModel.addMove(shouldAdd: true);
          if (gameBoardModel.puzzleSolved) {
            gameModel.markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowUp ||
          key == PhysicalKeyboardKey.keyW) {
        if (status == Status.playable && gameModel.useKeyboard) {
          final gridSize = gameModel.gridSize;
          gameBoardModel.moveColumnUp(gridSize: gridSize);
          gameModel.addMove(shouldAdd: true);
          if (gameBoardModel.puzzleSolved) {
            gameModel.markSolved();
          }
        }
      } else if (key == PhysicalKeyboardKey.arrowDown ||
          key == PhysicalKeyboardKey.keyS) {
        if (status == Status.playable && gameModel.useKeyboard) {
          final gridSize = gameModel.gridSize;
          gameBoardModel.moveColumnDown(gridSize: gridSize);
          gameModel.addMove(shouldAdd: true);
          if (gameBoardModel.puzzleSolved) {
            gameModel.markSolved();
          }
        }
      } else if (!visibleShortcuts && key == PhysicalKeyboardKey.space) {
        visibleShortcuts = true;
        showDialog(
            context: context,
            builder: (context) {
              return const _ShortcutsDialog();
            });
        visibleShortcuts = false;
      }
    }
    return true;
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

class _ShortcutsDialog extends StatelessWidget {
  const _ShortcutsDialog();

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
        _Shortcut(shortcut: 'P', altShortcut: 'Enter', label: 'Play (Shuffle)'),
        SizedBox(height: 12),
        _Shortcut(shortcut: '1', label: 'Select first row, column'),
        _Shortcut(shortcut: '2', label: 'Select second row, column'),
        _Shortcut(shortcut: '3', label: 'Select third row, column'),
        _Shortcut(shortcut: '4', label: 'Select fourth row, column'),
        SizedBox(height: 12),
        _Shortcut(
            shortcut: 'Up', altShortcut: 'W', label: 'Move selected column up'),
        _Shortcut(
            shortcut: 'Down',
            altShortcut: 'S',
            label: 'Move selected column down'),
        _Shortcut(
            shortcut: 'Left',
            altShortcut: 'A',
            label: 'Move selected row left'),
        _Shortcut(
            shortcut: 'Right',
            altShortcut: 'D',
            label: 'Move selected row right'),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('General'),
        ),
        _Shortcut(shortcut: 'Space', label: 'Show this window again'),
        _Shortcut(shortcut: 'Esc', label: 'Close this window'),
      ],
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.shortcut,
    this.altShortcut,
    required this.label,
  });

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
            decoration: BoxDecoration(
              border: Border.all(color: darkViolet, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                shortcut,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        if (altShortcut != null) ...[
          const Text('or'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: darkViolet, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  altShortcut!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
        Flexible(child: Text(label)),
      ],
    );
  }
}
