import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBoard extends AnimatedWidget {
  AnimatedBoard({
    Key? key,
    required this.child,
    required Animation<double> animation,
  })  : _animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0.7,
              1,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key, listenable: animation);

  final Widget child;
  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_animation.value * pi * 1.2),
      alignment: Alignment.center,
      child: child,
    );
  }
}
