import 'abacus_setting.dart';

class Player {
  final int id;
  final String name;
  final int suruPoint;
  final int mathPoint;
  final AbacusSetting? mathSetting;



  Player({
    required this.id,
    required this.name,
    this.mathSetting,
    this.suruPoint = 5,
    this.mathPoint = 5,
  });

  Player copyWith({
    String? name,
    int? suruPoint,
    int? mathPoint,
    AbacusSetting? mathSetting,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      suruPoint: suruPoint ?? this.suruPoint,
      mathPoint: mathPoint ?? this.mathPoint,
      mathSetting: mathSetting ?? this.mathSetting,
    );
  }
}
