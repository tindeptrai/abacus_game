import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final Stream<bool> loadingStream;
  final Widget child;
  final Color backgroundColor;

  const Loading({
    super.key,
    required this.loadingStream,
    required this.child,
    this.backgroundColor = Colors.black12,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          StreamBuilder<bool>(
            stream: widget.loadingStream,
            initialData: false,
            builder: (context, snapshot) => Visibility(
              visible: snapshot.data ?? false,
              child: Scaffold(
                backgroundColor: widget.backgroundColor,
                body: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
