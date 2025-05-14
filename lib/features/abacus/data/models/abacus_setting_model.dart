import 'package:hive/hive.dart';
import '../../../../shared/Shared.dart';
import '../../domain/domain.dart';

part 'abacus_setting_model.g.dart';

@HiveType(typeId: 2)
class AbacusSettingModel extends HiveObject {
  @HiveField(0)
  final int playerId;
  @HiveField(1)
  final String? numberColor;
  @HiveField(2)
  final String? backgroundColor;
  @HiveField(3)
  final String? name;
  @HiveField(4)
  final int? operator;
  @HiveField(5)
  final int? level;
  @HiveField(6)
  final int? sublevel;
  @HiveField(7)
  final int? digit;
  @HiveField(8)
  final double? speed;
  @HiveField(9)
  final int? rangeEnum;

  AbacusSettingModel({
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


  factory AbacusSettingModel.fromEntity(AbacusSetting mathSetting) {
    return AbacusSettingModel(
      playerId: mathSetting.playerId,
      numberColor: mathSetting.numberColor,
      backgroundColor: mathSetting.backgroundColor,
      name: mathSetting.name,
      operator: mathSetting.operator,
      level: mathSetting.level,
      sublevel: mathSetting.sublevel,
      digit: mathSetting.digit,
      speed: mathSetting.speed,
      rangeEnum: mathSetting.rangeEnum,
    );
  }

  AbacusSetting toEntity() {
    return AbacusSetting(
      playerId: playerId,
      numberColor: numberColor,
      backgroundColor: backgroundColor,
      name: name,
      operator: operator,
      level: level,
      sublevel: sublevel,
      digit: digit,
      speed: speed,
      rangeEnum: rangeEnum,
    );
  }
}
