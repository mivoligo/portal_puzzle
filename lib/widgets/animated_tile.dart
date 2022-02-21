import 'package:flutter/material.dart';
import 'package:portal_puzzle/models/models.dart';
import 'package:portal_puzzle/widgets/widgets.dart';

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    Key? key,
    required this.box,
    required this.text,
    required this.boardSize,
  }) : super(key: key);

  final GameBox box;
  final String text;
  final double boardSize;

  @override
  Widget build(BuildContext context) {
    return GameBoxTile(
      box: box,
      text: text,
      boardSize: boardSize,
    );
  }
}
