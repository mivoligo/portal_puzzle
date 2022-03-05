import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class AnimatedBoardBack extends StatefulWidget {
  const AnimatedBoardBack({Key? key}) : super(key: key);

  @override
  State<AnimatedBoardBack> createState() => _AnimatedBoardBackState();
}

class _AnimatedBoardBackState extends State<AnimatedBoardBack> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _confettiController.play();
      }),
      child: FractionallySizedBox(
        widthFactor: 0.4,
        heightFactor: 0.4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/box-base.png',
              fit: BoxFit.cover,
            ),
            // Image.asset(
            //   'assets/images/box-top.png',
            //   fit: BoxFit.cover,
            // ),
            Align(
              alignment: const FractionalOffset(0.5, 0.2),
              child: ConfettiMachine(
                confettiController: _confettiController,
              ),
            )
          ],
        ),
      ),
    );
  }
}
