import 'package:hive/hive.dart';
import '../../abacus.dart';
part 'abacus_game_state_model.g.dart';

@HiveType(typeId: 1)
class AbacusGameStateModel extends HiveObject {
  @HiveField(0)
  final String gameName;
  @HiveField(1)
  final int playerId;
  @HiveField(2)
  final int level;
  @HiveField(3)
  final int elapsedTime;

  AbacusGameStateModel({
    required this.gameName,
    required this.playerId,
    required this.level,
    required this.elapsedTime,
  });

  factory AbacusGameStateModel.fromEntity(AbacusGameState state) {
    return AbacusGameStateModel(
      playerId: state.playerId,
      gameName: state.gameName,
      level: state.level,
      elapsedTime: state.elapsedTime,
    );
  }

  AbacusGameState toEntity() {
    return AbacusGameState(
      playerId: playerId,
      gameName: gameName,
      level: level,
      elapsedTime: elapsedTime,
    );
  }
}
