import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as k;
import '../models/models.dart';
import 'widgets.dart';

class AnimatedBoardBack extends StatefulWidget {
  const AnimatedBoardBack({
    Key? key,
    required this.boardSize,
  }) : super(key: key);

  final double boardSize;

  @override
  State<AnimatedBoardBack> createState() => _AnimatedBoardBackState();
}

class _AnimatedBoardBackState extends State<AnimatedBoardBack> {
  bool opened = false;
  Timer? timer;
  late final ConfettiController confettiController = ConfettiController(
    duration: const Duration(seconds: 4),
  );

  @override
  void dispose() {
    confettiController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select<GameModel, Status>((model) => model.status);
    final gridSize = context.select<GameModel, int>((model) => model.gridSize);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const FractionalOffset(0.5, 0.6),
              colors: const [k.lightRose, k.violet],
              radius: gridSize / 3,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.boardSize * 0.05),
            ),
          ),
        ),
        Positioned(
          top: widget.boardSize * 0.01,
          left: widget.boardSize * 0.01,
          right: widget.boardSize * 0.01,
          bottom: widget.boardSize * 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.boardSize * 0.04),
                topRight: Radius.circular(widget.boardSize * 0.04),
              ),
            ),
            child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..rotateZ(pi)
                  ..rotateX(pi),
                child: const Center(child: SolvedMessage())),
          ),
        ),
        GestureDetector(
          onTap: status == Status.finished
              ? () => setState(() {
                    opened = !opened;
                    if (opened) {
                      confettiController.play();
                      timer = Timer(
                        const Duration(seconds: 4),
                        () => setState(() {
                          opened = false;
                        }),
                      );
                    } else {
                      confettiController.stop();
                      timer?.cancel();
                    }
                  })
              : null,
          child: FractionallySizedBox(
            widthFactor: 0.4,
            heightFactor: 0.4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  offset: opened ? const Offset(0, 0.2) : const Offset(0, 0.3),
                  child: Image.asset(
                    'assets/images/box-base.png',
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  offset: opened ? const Offset(0, -5) : const Offset(0, 0.3),
                  child: Image.asset(
                    'assets/images/box-top.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: const FractionalOffset(0.4, 0.4),
                  child: ConfettiMachine(
                    confettiController: confettiController,
                    starSize: widget.boardSize * 0.1,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
