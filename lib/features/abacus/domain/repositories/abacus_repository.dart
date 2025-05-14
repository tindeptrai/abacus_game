import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';
import '../domain.dart';

abstract class AbacusGameRepository {
    Future<Either<Failure, bool>> saveGameState(
    String gameName,
    int playerId,
    int level,
    int elapsedTime,
  );
  Future<Either<Failure, AbacusGameState?>> getLastGameState(
    int playerId,
    String gameName,
  );
  Future<Either<Failure, bool>> saveAbacusSetting(
    int playerId,
    String? numberColor,
    String? backgroundColor,
    String? name,
    int? operator,
    int? level,
    int? sublevel,
    int? digit,
    double? speed,
    int? rangeEnum,
  );

  Future<Either<Failure, AbacusSetting?>> getAbacusSetting(int playerId);
}
