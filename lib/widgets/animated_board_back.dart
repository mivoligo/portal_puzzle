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
  bool tapped = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select<GameModel, Status>((model) => model.status);
    final gridSize = context.select<GameModel, int>((model) => model.gridSize);

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: const [k.purple, k.lightRed],
          radius: gridSize / 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(widget.boardSize * 0.05),
        ),
      ),
      child: GestureDetector(
        onTap: status == Status.finished
            ? () => setState(() {
                  tapped = !tapped;
                  if (tapped) {
                    _confettiController.play();
                  } else {
                    _confettiController.stop();
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
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                offset: tapped ? const Offset(0, 0.2) : Offset.zero,
                child: Image.asset(
                  'assets/images/box-base.png',
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                offset: tapped ? const Offset(0, -5) : Offset.zero,
                child: Image.asset(
                  'assets/images/box-top.png',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.4, 0.3),
                child: ConfettiMachine(
                  confettiController: _confettiController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
