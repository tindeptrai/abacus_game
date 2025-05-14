import 'package:flutter/material.dart';

import '../../core.dart';

class ButtonCommon extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? disableColor;
  final Color? textColor;
  final bool enable;
  final BorderSide? border;
  final Widget? icon;
  final bool wrap;
  final double height;
  final double width;
  final EdgeInsetsGeometry? padding;
  final String? actionSound;

  const ButtonCommon({
    super.key,
    required this.onPressed,
    required this.label,
    this.textStyle,
    this.backgroundColor,
    this.textColor,
    this.disableColor = const Color(0xFFE5E5E5),
    this.enable = true,
    this.border,
    this.icon,
    this.wrap = false,
    this.height = 48,
    this.width = 0,
    this.padding,
    this.actionSound,
  });

  @override
  Widget build(BuildContext context) {
    final SoundHelper soundHelper = SoundHelper();

    return Container(
      margin: padding,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(Size(width, height)),
          elevation: WidgetStateProperty.all<double>(0.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return disableColor ?? const Color(0xFFE5E5E5);
            }
            return backgroundColor ?? Colors.teal;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFACACAC);
            }
            return textColor ?? Colors.white;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: border ?? BorderSide.none,
            ),
          ),
        ),
        onPressed: enable
            ? () async {
          if (actionSound != null) {
            soundHelper.playSound(action: actionSound!, context: context);
          }
          onPressed?.call();
        }
            : null,
        child: Row(
          mainAxisSize: wrap ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
