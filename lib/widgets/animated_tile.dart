import 'package:flutter/material.dart';

class AnimatedTile extends AnimatedWidget {
  AnimatedTile({
    Key? key,
    required this.child,
    required int index,
    required Animation<double> animation,
  })  : scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.05 * index,
              0.2 + 0.05 * index,
              curve: Curves.bounceInOut,
            ),
          ),
        ),
        super(key: key, listenable: animation);

  final Widget child;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleAnimation.value * 2 + 1,
      child: child,
    );
  }
}
