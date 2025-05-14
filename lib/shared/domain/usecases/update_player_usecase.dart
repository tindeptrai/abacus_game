import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../Shared.dart';

class UpdatePlayerUseCase {
  final SharedRepository sharedRepository;

  UpdatePlayerUseCase(this.sharedRepository);

  Future<Either<Failure, bool>> call(Player player) async {
    return await sharedRepository.updatePlayer(player.id, suruPoint: player.suruPoint, abacusPoint: player.mathPoint);
  }
}
