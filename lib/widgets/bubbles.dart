import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../constants.dart';

class Bubbles extends StatefulWidget {
  const Bubbles({Key? key}) : super(key: key);

  @override
  State<Bubbles> createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles> {
  late Timer timer;

  final bubbles = List<Bubble>.generate(10, (index) => Bubble());

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        for (final bubble in {...bubbles}) {
          bubble.position += Offset(bubble.dx, bubble.dy);
          if (bubble.position.dx < -80 ||
              bubble.position.dx > 80 ||
              bubble.position.dy < -50 ||
              bubble.position.dy > 50) {
            bubbles.remove(bubble);
            bubbles.add(Bubble());
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
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
      canvas.drawCircle(
        bubble.position,
        bubble.radius,
        Paint()..color = lightRedAA,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Bubble() {
    radius = random.nextDouble() * 8 + 2;
    position = Offset.zero;
    dx = random.nextDouble() * (1 + 1) - 1;
    dy = random.nextDouble() * (0.5 + 0.5) - 0.5;
  }

  final random = Random();
  late double radius;
  late double dx;
  late double dy;
  late Offset position;
}
