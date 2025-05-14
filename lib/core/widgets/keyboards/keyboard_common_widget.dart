import 'package:flutter/material.dart';

import '../../core.dart';

class KeyboardCommonWidget extends StatefulWidget {
  final Function(String) handleNumberPress;
  final Function()? handleDeletePress;
  final bool onlyNumberOneToNine;

  const KeyboardCommonWidget({super.key, required this.handleNumberPress, this.handleDeletePress, this.onlyNumberOneToNine = false});

  @override
  State<KeyboardCommonWidget> createState() => _KeyboardCommonWidgetState();
}

class _KeyboardCommonWidgetState extends State<KeyboardCommonWidget> {

  KeyboardMode keyboardModeSelect = KeyboardMode.center;
  final separatorPadding = 4.0;
  final heightRow = 36.0;
  List<String> listBottom = ['10', '9', '8', '7', '6', '-'];
  List<String> listTop = ['0', '1', '2', '3', '4'];

  Widget _buildNumberButton(
    String number, {
    VoidCallback? onPressed,
    double? width = 36,
    double? height = 36,
    bool enable = true,
  }) {
    return  SizedBox(
        width: width,
        height: height,
        child: SquareButtonCommon(
          onPressed: onPressed,
          actionSound: number,
          child: Text(
            number,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
    );
  }

  Widget buildTopLineKeyBoard() {
    double widthItem = (widthRow / (listTop.length + 1)) - separatorPadding;
    List<Widget> listWidget = listTop
        .map((e) => _buildNumberButton(
              e,
              onPressed: () => widget.handleNumberPress(e),
              width: widthItem,
              enable: widget.onlyNumberOneToNine ? e != '0' : true,
            ))
        .toList();
    final buttonControl = _buildControlButton(
      Icons.arrow_back,
      actionSound: "DELETE",
      isActive: true,
      onPressed: () => widget.handleDeletePress?.call(),
      width: widthItem,
    );
    listWidget.add(buttonControl);
    return SizedBox(
      height: heightRow,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, id) {
          return listWidget[id];
        },
        separatorBuilder: (_, __) => SizedBox(
          width: separatorPadding,
        ),
        itemCount: listWidget.length,
      ),
    );
  }

  Widget buildBottomLineKeyBoard() {
    double widthItem = (widthRow / (listBottom.length)) - separatorPadding;
    List<Widget> listWidget = listBottom
        .map(
          (e) => _buildNumberButton(
            e,
            onPressed: () => widget.handleNumberPress(e),
            width: widthItem,
            enable: widget.onlyNumberOneToNine ? e != '10' && e != '-' : true,
          ),
        )
        .toList();
    return SizedBox(
      height: heightRow,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, id) {
          return listWidget[id];
        },
        separatorBuilder: (_, __) => SizedBox(
          width: separatorPadding,
        ),
        itemCount: listWidget.length,
      ),
    );
  }

  Widget buildCenterRowKeyboard() {
    double widthItem = (widthRow / (listTop.length + 1)) - separatorPadding;
    return Row(
      children: [
        _buildNumberButton(
          'A',
          onPressed: () => widget.handleNumberPress('A'),
          width: widthItem,
          enable: !widget.onlyNumberOneToNine,
        ),
        SizedBox(
          width: separatorPadding,
        ),
        Expanded(
          child: _buildNumberButton(
            '5',
            onPressed: () => widget.handleNumberPress('5'),
          ),
        ),
        SizedBox(
          width: separatorPadding,
        ),
        _buildNumberButton(
          'Z',
          onPressed: () => widget.handleNumberPress('Z'),
          width: widthItem,
          enable: !widget.onlyNumberOneToNine,
        ),
        SizedBox(
          width: separatorPadding,
        ),
      ],
    );
  }

  Widget optionKeyboard(KeyboardMode keyboardMode, icon) {
    return _buildControlButton(
      icon,
      isActive: true,
      onPressed: () {
        setState(() {
          keyboardModeSelect = keyboardMode;
        });
      },
      tooltip: 'Đổi vị trí bàn phím',
    );
  }

  Widget _buildControlButton(
    IconData icon, {
    bool isActive = false,
    String? actionSound,
    VoidCallback? onPressed,
    String tooltip = '',
    double? width = 36,
    double? height = 36,
  }) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: width,
        height: height,
        child: SquareButtonCommon(
          onPressed: onPressed,
          actionSound: actionSound,
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }

  double get widthRow {
    return MediaQuery.of(context).size.width - heightRow * 2 - 16 - 16;
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (keyboardModeSelect != KeyboardMode.right) ...[
            optionKeyboard(keyboardModeSelect == KeyboardMode.left ? KeyboardMode.center : KeyboardMode.right,
                Icons.keyboard_arrow_left),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: keyboardModeSelect.crossAxisAlignment,
              children: [
                SizedBox(
                  width: widthRow,
                  child: buildBottomLineKeyBoard(),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: widthRow,
                  child: buildCenterRowKeyboard(),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: widthRow,
                  child: buildTopLineKeyBoard(),
                ),
              ],
            ),
          ),
          if (keyboardModeSelect != KeyboardMode.left) ...[
            const SizedBox(width: 8),
            optionKeyboard(keyboardModeSelect == KeyboardMode.right ? KeyboardMode.center : KeyboardMode.left,
                Icons.keyboard_arrow_right),
          ]
        ],
      );
}
