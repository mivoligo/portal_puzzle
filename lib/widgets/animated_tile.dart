import 'package:flutter/material.dart';

class AnimatedTile extends StatelessWidget {
  AnimatedTile({
    super.key,
    required this.child,
    required int gridSize,
    required double dx,
    required double dy,
    required Animation animation,
  })  : _slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0),
          end: Offset(-gridSize.toDouble(), 0),
        ).animate(
          CurvedAnimation(
            parent: animation as Animation<double>,
            curve: Interval(
              (dx / gridSize + dy * 0.05) * 0.7,
              ((dx + 1) / gridSize + dy * 0.05) * 0.7,
              curve: Curves.easeIn,
            ),
          ),
        ),
        _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              (dx / gridSize + dy * 0.05) * 0.7,
              ((dx + 1) / gridSize + dy * 0.05) * 0.7,
              curve: Curves.easeIn,
            ),
          ),
        );

  final Widget child;
  final Animation<Offset> _slideAnimation;
  final Animation<double> _opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}
