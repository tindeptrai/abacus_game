import 'package:flutter/material.dart';

class GetWidgetSize extends StatefulWidget {
  final ValueChanged<Size>? onSizeChange;
  final Widget child;

  const GetWidgetSize({
    required this.child,
    this.onSizeChange,
    super.key,
  });

  @override
  State<GetWidgetSize> createState() => _GetWidgetSizeState();
}

class _GetWidgetSizeState extends State<GetWidgetSize> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && context.size != null) {
        final size = context.size;
        widget.onSizeChange?.call(size!);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class GetWidgetSizeOnBuild extends StatefulWidget {
  final ValueChanged<Size?>? onSizeChange;
  final Widget child;

  const GetWidgetSizeOnBuild({
    required this.child,
    this.onSizeChange,
    super.key,
  });

  @override
  State<GetWidgetSizeOnBuild> createState() => _GetWidgetSizeOnBuildState();
}

class _GetWidgetSizeOnBuildState extends State<GetWidgetSizeOnBuild> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        final size = context.size;
        widget.onSizeChange?.call(size);
      }
    });

    return widget.child;
  }
}
