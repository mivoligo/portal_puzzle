import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBoard extends AnimatedWidget {
  AnimatedBoard({
    super.key,
    required this.finished,
    required this.front,
    required this.back,
    required Animation<double> animation,
  })  : _difficultyAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0.5,
              1,
              curve: Curves.easeInOut,
            ),
          ),
        ),
        _finishAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
        ),
        super(listenable: animation);

  final bool finished;
  final Widget front;
  final Widget back;

  final Animation<double> _difficultyAnimation;
  final Animation<double> _finishAnimation;

  @override
  Widget build(BuildContext context) {
    return finished
        ? Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_finishAnimation.value * pi),
            alignment: FractionalOffset.center,
            child: _finishAnimation.value < 0.5 ? front : back,
          )
        : Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_difficultyAnimation.value * pi * 0.45),
            alignment: FractionalOffset.center,
            child: front,
          );
  }
}
