import 'dart:math';

import 'package:flutter/material.dart';

import '../constants.dart';

class Bubbles extends StatefulWidget {
  const Bubbles({Key? key}) : super(key: key);

  @override
  State<Bubbles> createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {
  static final random = Random();

  final bubbles = List<Bubble>.generate(18, (index) => Bubble(random));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..forward();

    _controller.addListener(() {
      setState(() {
        for (final bubble in [...bubbles]) {
          bubble.position += Offset(bubble.dx, bubble.dy);
          if (bubble.position.dx < -90 ||
              bubble.position.dx > 90 ||
              bubble.position.dy < -60 ||
              bubble.position.dy > 60) {
            bubbles.remove(bubble);
            bubbles.add(Bubble(random));
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(bubbles),
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter(this.bubbles);

  final List<Bubble> bubbles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final opacity = 1.0 -
          min(
            bubble.position.dx.abs() / 90,
            bubble.position.dy.abs() / 60,
          );
      canvas.drawCircle(
        bubble.position,
        bubble.radius,
        Paint()..color = lightRose.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Bubble(Random random) {
    radius = random.nextDouble() * 8 + 2;
    position = Offset.zero;
    dx = random.nextDouble() * (1 + 1) - 1;
    dy = random.nextDouble() * (0.5 + 0.5) - 0.5;
  }

  late double radius;
  late double dx;
  late double dy;
  late Offset position;
}
