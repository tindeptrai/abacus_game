import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class SquareButtonCommon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? disableColor;
  final bool enable;
  final BorderSide? border;
  final Widget child;
  final bool wrap;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final  String? actionSound;

  const SquareButtonCommon({
    super.key,
    required this.onPressed,
    this.actionSound,
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
    SoundHelper soundHelper = SoundHelper();
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sharp corners
          ),
          padding: padding,
          backgroundColor: enable ? backgroundColor ?? Colors.teal.shade100 : disableColor,
        ),
        onPressed: () async {
          if (actionSound != null) {
            soundHelper.playSound(action: actionSound!, context: context);
          }
          if (enable) {
            onPressed?.call();
          }
        },
        child: child,
      ),
    );
  }
}
