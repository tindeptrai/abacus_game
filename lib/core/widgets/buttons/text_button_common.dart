import 'package:flutter/material.dart';

class TextButtonCommon extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? disabledColor;
  final bool enable;
  final BorderSide? border;
  final Widget? icon;
  final bool wrap;
  final EdgeInsetsGeometry? padding;

  const TextButtonCommon({
    super.key,
    required this.onPressed,
    required this.label,
    this.textStyle,
    this.textColor,
    this.enable = true,
    this.border,
    this.icon,
    this.wrap = false,
    this.disabledColor = const Color(0xFF767D86),
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: border ?? BorderSide.none,
        ),
      ),
      onPressed: enable ? onPressed : null,
      child: SizedBox(
        width: wrap ? null : double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 4),
            ],
            Text(
              label,
              textAlign: TextAlign.center,
              style: textStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: enable ? textColor : disabledColor),
            ),
          ],
        ),
      ),
    );
  }
}
