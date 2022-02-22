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
              0.5,
              1,
              curve: Curves.easeInOut,
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
        ..setEntry(3, 2, 0.00002)
        ..rotateY(_animation.value * pi * 0.6),
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}