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
      child: Column(
        children: [
          Transform.translate(
            offset: isPressed ? const Offset(0, 6) : const Offset(0, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
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
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xEE222222),
                      offset:
                          isPressed ? const Offset(0, 2) : const Offset(0, 8),
                      blurRadius: isPressed ? 2 : 12,
                      blurStyle: BlurStyle.outer),
                  BoxShadow(
                    color: const Color(0xFF991B1B),
                    offset: isPressed ? const Offset(0, 2) : const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
