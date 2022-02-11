import 'package:flutter/material.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _DifficultyButton(
          text: 'Simple',
          isSelected: false,
        ),
        _DifficultyButton(
          text: 'Medium',
          isSelected: true,
        ),
        _DifficultyButton(
          text: 'Hard',
          isSelected: false,
        ),
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    Key? key,
    required this.isSelected,
    required this.text,
  }) : super(key: key);

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: isSelected
            ? const TextStyle(color: Colors.orange)
            : const TextStyle(color: Colors.grey),
      ),
      onPressed: () {},
    );
  }
}
