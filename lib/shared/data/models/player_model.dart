import 'package:hive/hive.dart';
import '../../domain/domain.dart';

part 'player_model.g.dart';

@HiveType(typeId: 0)
class PlayerModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int suruPoint;
  @HiveField(3)
  final int abacusPoint;

  PlayerModel({
    required this.id,
    required this.name,
    required this.suruPoint,
    required this.abacusPoint,
  });

  factory PlayerModel.fromEntity(Player player) {
    return PlayerModel(
      id: player.id,
      name: player.name,
      suruPoint: player.suruPoint,
      abacusPoint: player.mathPoint,
    );
  }

  Player toEntity() {
    return Player(
      id: id,
      name: name,
      suruPoint: suruPoint,
      mathPoint: abacusPoint,
    );
  }
}
