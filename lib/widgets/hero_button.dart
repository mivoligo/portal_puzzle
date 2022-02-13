import 'package:flutter/material.dart';

class HeroButton extends StatefulWidget {
  const HeroButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;

  @override
  State<HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<HeroButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    double elevation = isPressed ? 0 : 6;
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() {
        isPressed = true;
      }),
      onTapUp: (_) => setState(() {
        isPressed = false;
      }),
      onTapCancel: () => setState(() {
        isPressed = false;
      }),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: elevation, end: elevation),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        builder: (_, double value, child) {
          return Transform.translate(
            offset: Offset(0, -value),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: child,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xEE222222),
                      offset: Offset(0, value + 2),
                      blurRadius: value + 2,
                      blurStyle: BlurStyle.outer),
                  BoxShadow(
                      color: const Color(0xFF991B1B),
                      offset: Offset(0, value + 2)),
                ],
              ),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.refresh,
              color: Color(0xFF7F1D1D),
            ),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: const TextStyle(
                color: Color(0xFF7F1D1D),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
