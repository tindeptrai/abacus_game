
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../core/core.dart';
import '../../../../core/presentation/screens/base_sofi_fun_state.dart';
import '../../../../shared/shared.dart';
import '../../../features.dart';


abstract class BaseSettingScreenState<P extends StatefulWidget> extends BaseSofiFunState<P, SettingGameCubit>{

  LevelEntities? level;
  bool isFirst = true;

  late AppLocalizations localizations;

  final colors = const [
    Color(0xFFFF0000), // Red
    Color(0xFFFF9800), // Orange
    Color(0xFFFFFF00), // Yellow
    Color(0xFF00FF00), // Green
    Color(0xFF0000FF), // Blue
    Color(0xFFFF00FF), // Purple
    Color(0xFF000000), // Black
    Color(0xFFFFFFFF), // White
    Color(0xFF808080), // Grey
  ];

  // Danh sách màu và quy luật tương ứng
  // Map<Color, List<Color>> goodColors = {
  //   const Color(0xFFFF0000): [const Color(0xFFFFFF00), const Color(0xFFFFFFFF)], // Red: yellow, white
  //   const Color(0xFFFF9800): [const Color(0xFFFFFF00), const Color(0xFFFFFFFF), const Color(0xFF000000)], // Orange: yellow, white, black
  //   const Color(0xFFFFFF00): [const Color(0xFFFF0000), const Color(0xFF0000FF), const Color(0xFFFF00FF), const Color(0xFF000000), const Color(0xFFFFFFFF), const Color(0xFF808080)], // Yellow: red, blue, purple, black, white, gray
  //   const Color(0xFF00FF00): [const Color(0xFF0000FF), const Color(0xFF000000), const Color(0xFF808080)], // Green: blue, black, gray
  //   const Color(0xFF0000FF): [const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFFFFFFFF)], // Blue: yellow, green, white
  //   const Color(0xFFFF00FF): [const Color(0xFF000000), const Color(0xFFFFFFFF)], // Purple: black, white
  //   const Color(0xFF000000): [const Color(0xFFFF0000), const Color(0xFFFF9800), const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFFFF00FF), const Color(0xFFFFFFFF)], // Black: red, orange, yellow, green, purple, white
  //   const Color(0xFFFFFFFF): [const Color(0xFFFF0000), const Color(0xFFFFFF00), const Color(0xFF0000FF), const Color(0xFFFF00FF), const Color(0xFF000000), const Color(0xFF808080)], // White: red, yellow, blue, purple, black, gray
  //   const Color(0xFF808080): [const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFFFFFFFF)], // Gray: yellow, green, white
  // };
  // bool isGoodColorMatch(Color backgroundColor, Color foreColor) {
  //   if (goodColors.containsKey(backgroundColor)) {
  //     return goodColors[backgroundColor]!.contains(foreColor);
  //   }
  //
  //   return false;
  // }

  Color getNextGoodColor(Color currentColor, Color backgroudColor,
      {bool? needGoodColor = false}) {
    int index = colors.indexOf(currentColor);
    for (int i = index + 1; i < colors.length; i++) {
      final goodColor = (needGoodColor ?? false)
          ? ColorHelper.isContrastGood(backgroudColor, colors[i])
          : true;
      if (colors[i] != backgroudColor && goodColor) {
        return colors[i];
      }
    }

    for (int i = 0; i < index; i++) {
      final goodColor = (needGoodColor ?? false)
          ? ColorHelper.isContrastGood(backgroudColor, colors[i])
          : true;
      if (colors[i] != backgroudColor && goodColor) {
        return colors[i];
      }
    }
    return currentColor;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
    if (isFirst) {
      isFirst = false;
      final mathArg = ModalRoute.of(context)?.settings.arguments;
      if (mathArg is MathArg) {
        cubit.math = mathArg;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        cubit.initData();
      });
    }
  }

  Future<void> _showBottomSheetSelectLevel(int maxLevel,
      {bool showSubLevel = false}) async {
    final List<int> levels = List.generate(maxLevel, (index) => index + 1);
    Map<String, List<int>> subLevels = {
      for (int i = 1; i <= maxLevel; i++) '$i': List.generate(4, (j) => (j + 1))
    };
    if (showSubLevel == false) subLevels = {};
    final rs = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BottomSheetContent(
            levels: levels, subLevels: subLevels, localizations: localizations);
      },
    );
    if (rs != null) {
      int level = rs.$1;
      int subLevel = rs.$2;
      var levelEntities = LevelEntities(level: level, subLevel: subLevel);
      cubit.onChangeLevel(levelEntities);
    }
  }

  void _showNumberPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return NumberPickerBottomSheet(
          localizations: localizations,
          onPickNumber: (value) {
            cubit.onChangeDigitCount(value);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showSpeedPicker({
    required Function(double) onNumberSelected,
    double? initValue,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return NumberSpeedPickerBottomSheet(
          onNumberSelected: onNumberSelected,
          initValue: initValue,
        );
      },
    );
  }

  void handleBackGroundColor(Color backgroundColor, Color numberColor) {
    final nextColor =
    getNextGoodColor(backgroundColor, numberColor, needGoodColor: false);
    final hexColor =
        '#${nextColor.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
    cubit.onChangeBackGroundColor(hexColor);
    if (ColorHelper.isContrastGood(nextColor, numberColor) == false) {
      final nextColor2 =
      colors.firstWhere((e) => ColorHelper.isContrastGood(nextColor, e));
      final hexColor2 =
          '#${nextColor2.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
      cubit.onChangeNumberColor(hexColor2);
    }
  }

  String get titleAppBarText => localizations.game_settings;

  Widget levelWidget(String levelDisplay, bool isMultiOrDivision) =>
      CustomContainer(
        title: localizations.level,
        value: levelDisplay,
        onPressed: () {
          int maxLevel = 10;
          _showBottomSheetSelectLevel(maxLevel,
              showSubLevel: isMultiOrDivision);
        },
        color: const Color(0xFF1B5E20),
      );

  Widget digitWidget(int digit, bool disableDigit) => CustomContainer(
    title: localizations.number_of_digits,
    value: "$digit",
    disable: disableDigit,
    subWidget: TypeWriterEffect(
      text: "${localizations.example}: 2 : 1 + 1, 3: 1 + 1 + 1",
      textStyle: const TextStyle(fontSize: 14, color: Colors.white),
    ),
    onPressed: () {
      _showNumberPicker();
    },
    color: const Color(0xFF2E7D32),
  );

  Widget speedWidget(double speed) => CustomContainer(
    title: "${localizations.display_speed} (s)",
    value: "$speed",
    onPressed: () {
      _showSpeedPicker(
        onNumberSelected: (value) {
          cubit.onChangeSpeed(value);
        },
        initValue: speed,
      );
    },
    color: const Color(0xFF2b961f),
  );

  Widget rangeWidget(NumberRangeEnum rangeEnum) {
    return CustomContainer(
      title: localizations.rangeTitle,
      value: rangeEnum.localized(localizations),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) {
            return PickerBottomSheet<NumberRangeEnum>(
              onChange: cubit.onChangeRange,
              localizations: localizations,
              initValue: rangeEnum,
              items: NumberRangeEnum.values,
              valueShow: (range) => range.localized(localizations),
            );
          },
        );
      },
      color: const Color(0xFF66BB6A),
    );
  }

  Widget backgroundColorWidget(Color backgroundColor, Color numberColor) {
    return CustomContainer(
      title: localizations.backgroundColor,
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
      ),
      onPressed: () {
        handleBackGroundColor(backgroundColor, numberColor);
      },
      color: const Color(0xFF81C784),
    );
  }

  Widget numberColorWidget(Color numberColor, Color backgroundColor) {
    return CustomContainer(
      title: localizations.numberColor,
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: numberColor,
        ),
      ),
      onPressed: () {
        final nextColor =
        getNextGoodColor(numberColor, backgroundColor, needGoodColor: true);
        final hexColor =
            '#${nextColor.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
        cubit.onChangeNumberColor(hexColor);
      },
      color: const Color(0xFF81C784),
    );
  }

  Widget operatorWidget(Operator operator) {
    return CustomContainer(
      title: localizations.choose_operation,
      value: operator.localized(localizations),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) {
            return PickerBottomSheet<Operator>(
              onChange: cubit.onChangeOperation,
              localizations: localizations,
              initValue: operator,
              items: Operator.values,
              valueShow: (operator) => operator.localized(localizations),
            );
          },
        );
      },
      color: const Color(0xFF81C784),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'SoFiFunNumber',
      ),
      child: BlocBuilder<SettingGameCubit, SettingGameState>(
        bloc: cubit,
        builder: (context, state) {
          final isMulAndDi = state.operator == Operator.division ||
              state.operator == Operator.multiplication;
          final levelDisplay = !isMulAndDi
              ? "${state.level.level}"
              : "${state.level.level} - ${state.level.subLevel}";
          final numberColor = ColorHelper.hexToColor(state.numberColor);
          final backgroundColor = ColorHelper.hexToColor(state.backgroundColor);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(titleAppBarText),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chọn Level
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          levelWidget(levelDisplay, state.isMultiOrDivision),
                          const SizedBox(
                            height: 16,
                          ),
                          digitWidget(state.digit, state.disableDigit),
                          if (!isMulAndDi) ...[
                            const SizedBox(
                              height: 16,
                            ),
                            speedWidget(state.speed),
                            const SizedBox(
                              height: 16,
                            ),
                            rangeWidget(state.rangeEnum),
                          ],
                          const SizedBox(
                            height: 16,
                          ),
                          numberColorWidget(numberColor, backgroundColor),
                          const SizedBox(
                            height: 16,
                          ),
                          backgroundColorWidget(backgroundColor, numberColor),
                          const SizedBox(
                            height: 16,
                          ),
                          operatorWidget(state.operator),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ButtonCommon(
                    onPressed: () async {
                      await cubit.pushToAbacusGame();
                    },
                    label: localizations.start,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? subWidget;
  final Color color;
  final Widget? trailing;
  final Function? onPressed;
  final bool? disable;

  const CustomContainer({
    super.key,
    required this.title,
    this.value,
    this.subWidget,
    this.color = Colors.green, // Màu mặc định
    this.onPressed,
    this.trailing, // Màu mặc định
    this.disable, // Màu mặc định
  });

  @override
  Widget build(BuildContext context) {
    final isDisable = disable == true;
    return GestureDetector(
      onTap: () => isDisable ? {} : onPressed?.call(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isDisable ? Colors.grey : color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: trailing ??
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              value ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            Icons.arrow_circle_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                )
              ],
            ),
            subWidget ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class TypeWriterEffect extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;

  const TypeWriterEffect({super.key, required this.text, this.textStyle});

  @override
  State createState() => _TypeWriterEffectState();
}

class _TypeWriterEffectState extends State<TypeWriterEffect> {
  String _displayedText = "";
  int _charIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _startTypingEffect();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  void _startTypingEffect() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_charIndex];
          _charIndex++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.textStyle ??
          const TextStyle(fontSize: 14, color: Colors.white),
    );
  }
}

class InputMaxFormatter extends TextInputFormatter {
  final int maxValue;

  InputMaxFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newV = int.tryParse(newValue.text);
    if (newV == null) return newValue;
    if (newV > maxValue) {
      newV = maxValue;
    }
    final offset = newV.toString().isNotEmpty ? newV.toString().length : -1;
    return TextEditingValue(
      text: newV.toString(),
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

class NumberPickerBottomSheet extends StatelessWidget {
  final AppLocalizations localizations;
  final Function(int) onPickNumber;

  const NumberPickerBottomSheet({
    super.key,
    required this.localizations,
    required this.onPickNumber,
  });

  List<int> _generateLevels() {
    return List<int>.generate(50, (index) => index + 1);
  }

  Map<String, List<int>> _groupLevelsByRange(List<int> levels) {
    Map<String, List<int>> groupedLevels = {
      '2 ~ 10:': [],
      '11 ~ 20:': [],
      '21 ~ 30:': [],
      '31 ~ 40:': [],
      '41 ~ 50:': [],
    };

    for (var level in levels) {
      if (level >= 2 && level <= 10) {
        groupedLevels['2 ~ 10:']!.add(level);
      } else if (level >= 11 && level <= 20) {
        groupedLevels['11 ~ 20:']!.add(level);
      } else if (level >= 21 && level <= 30) {
        groupedLevels['21 ~ 30:']!.add(level);
      } else if (level >= 31 && level <= 40) {
        groupedLevels['31 ~ 40:']!.add(level);
      } else if (level >= 41 && level <= 50) {
        groupedLevels['41 ~ 50:']!.add(level);
      }
    }

    return groupedLevels;
  }

  @override
  Widget build(BuildContext context) {
    final levels = _generateLevels();
    final groupedLevels = _groupLevelsByRange(levels);
    return Theme(
      data: ThemeData(
        fontFamily: 'SoFiFunNumber',
      ),
      child: Container(
        constraints:
        BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: ListView.builder(
          itemCount: groupedLevels.keys.length,
          itemBuilder: (context, index) {
            final range = groupedLevels.keys.elementAt(index);
            final rangeLevels = groupedLevels[range]!;
            return ExpansionTile(
              title: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  range,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              children: rangeLevels.map((level) {
                return GestureDetector(
                  onTap: () {
                    onPickNumber(level);
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 4),
                      decoration: BoxDecoration(
                        color: level % 2 == 0
                            ? Colors.green[50]
                            : Colors.green[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "• $level",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'SoFiFunNumber',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final List<int> levels;
  final Map<String, List<int>> subLevels;
  final AppLocalizations localizations;

  const BottomSheetContent({
    super.key,
    required this.levels,
    required this.subLevels,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'SoFiFunNumber',
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            0.8, // Chiều cao của Bottom Sheet
        child: ListView.builder(
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];
            final subLevelList = subLevels[level.toString()] ?? [];
            if (subLevelList.isEmpty) {
              return ListTile(
                title: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Level $level",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                onTap: () {
                  Navigator.pop(
                      context, (level, 0)); // Đóng Bottom Sheet nếu cần
                },
              );
            }

            return ExpansionTile(
              title: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "• ${localizations.level} $level",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              children: subLevelList.map((subLevel) {
                return ListTile(
                  title: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: subLevel % 2 == 0
                          ? Colors.green[50]
                          : Colors.green[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${localizations.level} $level - ${subLevel.toString()}",
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context,
                        (level, subLevel)); // Đóng Bottom Sheet nếu cần
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class NumberSpeedPickerBottomSheet extends StatelessWidget {
  final double? initValue;
  final Function(double) onNumberSelected;

  const NumberSpeedPickerBottomSheet({
    super.key,
    required this.onNumberSelected,
    this.initValue,
  });

  @override
  Widget build(BuildContext context) {
    const quantity = 10;
    final numbers = List.generate(quantity, (index) => 0.25 * (1 + index));
    return Theme(
      data: ThemeData(
        fontFamily: 'SoFiFunNumber',
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: initValue == numbers[index]
                      ? Colors.green
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  numbers[index].toString(),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                onNumberSelected(numbers[index]); // Gửi số đã chọn
                Navigator.pop(context); // Đóng BottomSheet
              },
            );
          },
        ),
      ),
    );
  }
}

class PickerBottomSheet<T> extends StatelessWidget {
  final Function(T) onChange;
  final AppLocalizations localizations;
  final T? initValue;
  final List<T> items;
  final String Function(T) valueShow;

  const PickerBottomSheet({
    required this.onChange,
    required this.localizations,
    required this.items,
    required this.valueShow,
    this.initValue,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'SoFiFunNumber',
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: initValue == items[index]
                      ? Colors.green
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  // Operator.values[index].localized(localizations),
                  valueShow(items[index]),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                onChange(items[index]); // Gửi số đã chọn
                Navigator.pop(context); // Đóng BottomSheet
              },
            );
          },
        ),
      ),
    );
  }
}