import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class SharedRepositoryImpl implements SharedRepository {
  final SharedHiveHelper gameHiveHelper;

  SharedRepositoryImpl({required this.gameHiveHelper});

  @override
  Future<Either<Failure, Player?>> getLastPlayer() async {
    try {
      final gameState = await gameHiveHelper.getLastedPlayer();
      return Right(gameState);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to get last player'));
    }
  }

  @override
  Future<Either<Failure, Player?>> getLastPlayerByName(int playerId) async {
    try {
      final success = await gameHiveHelper.getPlayerById(playerId);
      return Right(success);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to get last player'));
    }
  }

  @override
  Future<Either<Failure, Player>> savePlayer(String playerName) async {
    try {
      final player = await gameHiveHelper.addPlayer(playerName);
      return Right(player);
    } catch (e) {
      return Left(DatabaseFailure('Failed to Save Player: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePlayer(int playerId,
      {int? suruPoint, int? abacusPoint}) async {
    try {
      final success = await gameHiveHelper.updatePlayer(playerId,
          suruPoint: suruPoint, abacusPoint: abacusPoint);
      return Right(success);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to Update Player'));
    }
  }
}
