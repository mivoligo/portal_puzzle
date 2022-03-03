import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart' as k;
import 'models/models.dart';
import 'widgets/widgets.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
    required this.parentSize,
    required this.animationController,
  }) : super(key: key);

  final double parentSize;
  final Animation<double> animationController;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  double localX = 0;
  double localY = 0;
  bool defaultPosition = true;

  @override
  Widget build(BuildContext context) {
    final status = context.watch<GameModel>().status;
    final gridSize = context.watch<GameModel>().gridSize;
    final boxes = context.watch<GameBoardModel>().boxes;
    double boardSize = widget.parentSize;
    final boardColor = context.watch<GameModel>().boardColor;

    double percentX = (localX / boardSize) * 100;
    double percentY = (localY / boardSize) * 100;

    return Center(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: status == Status.playable || status == Status.finished ? 1 : 0.8,
        curve: Curves.decelerate,
        child: SizedBox(
          width: boardSize * 1.1,
          height: boardSize * 1.1,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(defaultPosition ? 0 : (0.1 * (percentY / 50) - 0.1))
              ..rotateY(defaultPosition ? 0 : (-0.1 * (percentX / 50) + 0.1)),
            alignment: FractionalOffset.center,
            child: AnimatedBoard(
              finished: status == Status.finished,
              animation: widget.animationController,
              back: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      boardColor,
                      k.lightRed,
                    ],
                    center: FractionalOffset(
                      localX / boardSize,
                      localY / boardSize,
                    ),
                    radius: gridSize / 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(boardSize * 0.05),
                  ),
                ),
                child: FractionallySizedBox(
                    widthFactor: 0.4,
                    heightFactor: 0.42,
                    child: Image.asset(
                      'assets/images/gift.png',
                      fit: BoxFit.cover,
                    )),
              ),
              front: AnimatedContainer(
                clipBehavior: Clip.antiAlias,
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.all(boardSize * 0.05),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      boardColor,
                      k.lightRed,
                    ],
                    center: FractionalOffset(
                      localX / boardSize,
                      localY / boardSize,
                    ),
                    radius: gridSize / 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(boardSize * 0.05),
                  ),
                ),
                child: GestureDetector(
                  onHorizontalDragStart: status == Status.playable
                      ? (details) {
                          setState(() {
                            defaultPosition = false;
                          });
                          context.read<GameBoardModel>().setTappedRow(
                                boardSize: boardSize,
                                gridSize: gridSize,
                                details: details,
                              );
                        }
                      : null,
                  onVerticalDragStart: status == Status.playable
                      ? (details) {
                          setState(() {
                            defaultPosition = false;
                          });
                          context.read<GameBoardModel>().setTappedColumn(
                                boardSize: boardSize,
                                gridSize: gridSize,
                                details: details,
                              );
                        }
                      : null,
                  onHorizontalDragUpdate: status == Status.playable
                      ? (details) {
                          setState(() {
                            updatePanning(details, boardSize);
                          });
                          context
                              .read<GameBoardModel>()
                              .dragRow(details, gridSize, boardSize);
                        }
                      : null,
                  onVerticalDragUpdate: status == Status.playable
                      ? (details) {
                          setState(() {
                            updatePanning(details, boardSize);
                          });
                          context
                              .read<GameBoardModel>()
                              .dragColumn(details, gridSize, boardSize);
                        }
                      : null,
                  onHorizontalDragEnd: status == Status.playable
                      ? (detail) {
                          setState(() {
                            defaultPosition = true;
                          });
                          context.read<GameBoardModel>().snapBoxes();
                          context.read<GameBoardModel>().updateBoxesLocation();
                          final boxesChanged =
                              context.read<GameBoardModel>().boxesChanged;
                          context
                              .read<GameModel>()
                              .addMove(shouldAdd: boxesChanged);
                          if (context.read<GameBoardModel>().puzzleSolved) {
                            context.read<GameModel>().markSolved();
                          }
                        }
                      : null,
                  onVerticalDragEnd: status == Status.playable
                      ? (detail) {
                          setState(() {
                            defaultPosition = true;
                          });
                          context.read<GameBoardModel>().snapBoxes();
                          context.read<GameBoardModel>().updateBoxesLocation();
                          final boxesChanged =
                              context.read<GameBoardModel>().boxesChanged;
                          context
                              .read<GameModel>()
                              .addMove(shouldAdd: boxesChanged);
                          if (context.read<GameBoardModel>().puzzleSolved) {
                            context.read<GameModel>().markSolved();
                          }
                        }
                      : null,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x22FFFFFF),
                          borderRadius: BorderRadius.all(
                            Radius.circular(boardSize * 0.01),
                          ),
                        ),
                      ),
                      ...boxes.map(
                        (box) {
                          final index = boxes.indexOf(box);
                          final gameBoxRect = box.getRect(
                            boardSize: boardSize,
                            gridSize: gridSize,
                          );
                          return AnimatedPositioned(
                            duration: status != Status.shuffling
                                ? Duration.zero
                                : const Duration(milliseconds: 150),
                            left: gameBoxRect.left,
                            top: gameBoxRect.top,
                            child: AnimatedTile(
                              gridSize: gridSize,
                              dx: box.currentLoc.dx,
                              dy: box.currentLoc.dy,
                              child: GameBoxTile(
                                box: box,
                                text: '${index + 1}',
                                boardSize: boardSize,
                              ),
                              animation: widget.animationController,
                            ),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updatePanning(DragUpdateDetails details, double boardSize) {
    if (details.localPosition.dx > 0 &&
        details.localPosition.dx < boardSize &&
        details.localPosition.dy > 0 &&
        details.localPosition.dy < boardSize) {
      localX = details.localPosition.dx;
      localY = details.localPosition.dy;
    }
  }
}
