import 'package:flutter/material.dart';

class CircleButtonCommon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? disableColor;
  final bool enable;
  final BorderSide? border;
  final Widget child;
  final bool wrap;
  final double size;
  final EdgeInsetsGeometry? padding;

  const CircleButtonCommon({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.disableColor = const Color(0xFFE5E5E5),
    this.enable = true,
    this.border,
    this.wrap = false,
    this.size = 48,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: padding,
          backgroundColor: backgroundColor ?? Colors.teal.shade100,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
