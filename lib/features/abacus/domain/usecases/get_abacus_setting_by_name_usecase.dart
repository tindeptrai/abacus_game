import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';
import '../domain.dart';

class GetAbacusSettingByNameUseCase{
  final AbacusGameRepository repository;

  GetAbacusSettingByNameUseCase(this.repository);

  Future<Either<Failure, AbacusSetting?>> call(int? playerId) async {
    if (playerId == null) {
      return const Right(null);
    }
    return await repository.getAbacusSetting(playerId);
  }
}
