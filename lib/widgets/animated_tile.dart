import 'package:flutter/material.dart';

class AnimatedTile extends StatelessWidget {
  AnimatedTile({
    Key? key,
    required this.child,
    required int index,
    required Animation<double> animation,
  })  : _scaleAnimation = Tween<double>(begin: 1.0, end: 4.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.05 * index,
              0.2 + 0.05 * index,
              curve: Curves.easeIn,
            ),
          ),
        ),
        _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              0.05 * index,
              0.2 + 0.05 * index,
              curve: Curves.easeInOut,
            ),
          ),
        ),
        super(key: key);

  final Widget child;
  final Animation<double> _scaleAnimation;
  final Animation<double> _opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}
