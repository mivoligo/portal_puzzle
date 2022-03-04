import 'package:flutter/material.dart';

class HeroButton extends StatefulWidget {
  const HeroButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.surfaceColor,
    required this.sideColor,
    required this.textColor,
    this.iconData,
    this.isSmall = true,
    this.isSelected = false,
  }) : super(key: key);

  final String label;
  final Color surfaceColor;
  final Color sideColor;
  final Color textColor;
  final IconData? iconData;
  final bool isSmall;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  State<HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<HeroButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    double elevation = isPressed || widget.isSelected
        ? 0
        : widget.isSmall
            ? 4
            : 6;
    return GestureDetector(
      onTap: widget.isSelected ? null : widget.onPressed,
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
              padding: widget.isSmall
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                  : const EdgeInsets.all(16),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: child,
              ),
              decoration: BoxDecoration(
                color: widget.surfaceColor,
                borderRadius: widget.isSmall
                    ? const BorderRadius.all(Radius.circular(8))
                    : const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xEE222222),
                    offset: Offset(0, value + 2),
                    blurRadius: value + 2,
                    blurStyle: BlurStyle.outer,
                  ),
                  BoxShadow(
                    color: widget.sideColor,
                    offset: Offset(0, value + 2),
                  ),
                ],
              ),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.iconData != null)
              Icon(
                widget.iconData,
                color: widget.isSelected
                    ? const Color(0xFFFFFFFF)
                    : widget.textColor,
              ),
            if (widget.iconData != null) const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected
                    ? const Color(0xFFFFFFFF)
                    : widget.textColor,
                fontSize: widget.isSmall ? 14 : 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
