import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class SettingGameState extends Equatable {
  final LevelEntities level;
  final int digit;
  final Operator operator;
  final bool disableDigit;
  final double speed;
  final NumberRangeEnum rangeEnum;
  final String numberColor;
  final String backgroundColor;


  const SettingGameState({
    required this.level,
    this.digit = 2,
    this.speed = 1.0,
    this.operator = Operator.addition,
    this.disableDigit = false,
    this.rangeEnum = NumberRangeEnum.all,
    this.numberColor = '#FFFFFF',
    this.backgroundColor = '#000000',
  });

  bool get isMultiOrDivision =>  operator == Operator.multiplication || operator == Operator.division;

  @override
  List<Object> get props => [
        level,
        digit,
        operator,
        disableDigit,
        speed,
        rangeEnum,
        numberColor,
        backgroundColor,
      ];

  SettingGameState copyWith({
    LevelEntities? level,
    int? digit,
    double? speed,
    Operator? operator,
    bool? disableDigit,
    NumberRangeEnum? rangeEnum,
    String? numberColor,
    String? backgroundColor,
  }) {
    return SettingGameState(
      level: level ?? this.level,
      digit: digit ?? this.digit,
      speed: speed ?? this.speed,
      operator: operator ?? this.operator,
      disableDigit: disableDigit ?? this.disableDigit,
      rangeEnum: rangeEnum ?? this.rangeEnum,
      numberColor: numberColor ?? this.numberColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
