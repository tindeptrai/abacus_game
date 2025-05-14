import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';
import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class AbacusGameRepositoryImpl implements AbacusGameRepository {
  final AbacusGameHiveHelper hiveHelper;

  AbacusGameRepositoryImpl(this.hiveHelper);

  @override
  Future<Either<Failure, AbacusGameState?>> getLastGameState(int playerId, String gameName) async {
    try {
      final gameState = await hiveHelper.getLastGameByPlayerIdAndGameName(playerId, gameName);
      return Right(gameState);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to get last game'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveGameState(String gameName, int playerId, int level, int elapsedTime) async {
    try {
      final success = await hiveHelper.updateGameState(
        AbacusGameState(
          playerId: playerId,
          gameName: gameName,
          level: level,
          elapsedTime: elapsedTime,
        ),
      );
      return Right(success);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to Save Game State'));
    }
  }

  @override
  Future<Either<Failure, AbacusSetting?>> getAbacusSetting(int playerId) async {
    try {
      final mathSetting = await hiveHelper.getAbacusSettingByPlayerId(playerId);
      return Right(mathSetting);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to get math setting'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveAbacusSetting(int playerId, String? numberColor, String? backgroundColor,
      String? name, int? operator, int? level, int? sublevel, int? digit, double? speed, int? rangeEnum) async {
    try {
      final success = await hiveHelper.updateAbacusSetting(
        AbacusSetting(
          playerId: playerId,
          backgroundColor: backgroundColor,
          numberColor: numberColor,
          name: name,
          operator: operator,
          level: level,
          sublevel: sublevel,
          digit: digit,
          speed: speed,
          rangeEnum: rangeEnum,
        ),
      );
      return Right(success);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to Save Math Setting'));
    }
  }
}
