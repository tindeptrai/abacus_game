
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class MathArg {

  Player player;
  LevelEntities? level;
  int? digit;
  double? speed;
  final bool? isContinue;
  Operator? operator;
  NumberRangeEnum? numberRange;

  MathArg({
    required this.player,
    this.level,
    this.digit = 2,
    this.isContinue,
    this.operator,
    this.speed,
    this.numberRange,
  });
}