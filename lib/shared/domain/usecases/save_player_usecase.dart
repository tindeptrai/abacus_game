import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../Shared.dart';

class SavePlayerUseCase {
  final SharedRepository sharedRepository;

  SavePlayerUseCase(this.sharedRepository);

  Future<Either<Failure, Player?>> call(String playerName) async {
    return await sharedRepository.savePlayer(playerName);
  }
}
