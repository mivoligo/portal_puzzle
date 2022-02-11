import 'package:flutter/material.dart';

class MovesCounter extends StatelessWidget {
  const MovesCounter({
    Key? key,
    required this.movesCount,
    this.isLarge = false,
  }) : super(key: key);

  final int movesCount;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Moves: $movesCount',
      style: isLarge
          ? const TextStyle(fontSize: 32)
          : const TextStyle(fontSize: 24),
    );
  }
}
