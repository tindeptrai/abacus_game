import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../shared.dart';

abstract class SharedRepository {
  Future<Either<Failure, Player>> savePlayer(String playerName);
  Future<Either<Failure, bool>> updatePlayer(int playerId, {int? suruPoint, int? abacusPoint});
  Future<Either<Failure, Player?>> getLastPlayer();
  Future<Either<Failure, Player?>> getLastPlayerByName(int playerId);
}
