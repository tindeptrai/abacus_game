import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class AbacusSetting {
  final int playerId;
  final String? numberColor;
  final String? backgroundColor;
  final String? name;
  final int? operator;
  final int? level;
  final int? sublevel;
  final int? digit;
  final double? speed;
  final int? rangeEnum;

  Color get backgroundColorShow =>
      ColorHelper.hexToColor(backgroundColor ?? "");

  Color get numberColorShow => ColorHelper.hexToColor(numberColor ?? "");

  AbacusSetting({
    required this.playerId,
    this.numberColor,
    this.backgroundColor,
    this.name,
    this.operator,
    this.level,
    this.sublevel,
    this.digit,
    this.speed,
    this.rangeEnum,
  });

  AbacusSetting copyWith(
    String? numberColor,
    String? backgroundColor,
    String? name,
    int? operator,
    int? level,
    int? sublevel,
    int? digit,
    double? speed,
    int? rangeEnum,
  ) =>
      AbacusSetting(
        playerId: playerId,
        numberColor: numberColor ?? this.numberColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        name: name ?? this.name,
        operator: operator ?? this.operator,
        level: level ?? this.level,
        sublevel: sublevel ?? this.sublevel,
        digit: digit ?? this.digit,
        speed: speed ?? this.speed,
        rangeEnum: rangeEnum ?? this.rangeEnum,
      );
}
