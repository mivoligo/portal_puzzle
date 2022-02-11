import 'package:flutter/material.dart';

class HeroButton extends StatelessWidget {
  const HeroButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.refresh),
      label:  Text(label),
      style: TextButton.styleFrom(
          backgroundColor: Colors.orange,
          primary: Colors.white,
          padding: const EdgeInsets.all(24)),
      onPressed: onPressed,
    );
  }
}
