import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiMachine extends StatelessWidget {
  const ConfettiMachine({
    Key? key,
    required this.confettiController,
  }) : super(key: key);

  final ConfettiController confettiController;

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfettiWidget(
          confettiController: confettiController,
          blastDirection: -pi * 0.3,
          // blastDirectionality: BlastDirectionality.explosive,
          // minBlastForce: 30,
          maxBlastForce: 30,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
          createParticlePath: (_) => drawStar(const Size(50, 50)),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          blastDirection: -pi * 0.5,
          // blastDirectionality: BlastDirectionality.explosive,
          // minBlastForce: 30,
          maxBlastForce: 30,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
          createParticlePath: (_) => drawStar(const Size(50, 50)),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          blastDirection: -pi * 0.7,
          // blastDirectionality: BlastDirectionality.explosive,
          // minBlastForce: 30,
          maxBlastForce: 30,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
          createParticlePath: (_) => drawStar(const Size(50, 50)),
        ),
      ],
    );
  }
}
