import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';

class GetLastPlayerByIdUseCase {
  final SharedRepository sharedRepository;

  GetLastPlayerByIdUseCase(this.sharedRepository);

  Future<Either<Failure, Player?>> call(int playerId) async {
    return await sharedRepository.getLastPlayerByName(playerId);
  }
}
