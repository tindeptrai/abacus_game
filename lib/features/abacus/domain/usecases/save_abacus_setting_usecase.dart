import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';
import '../domain.dart';

class SaveAbacusSettingUseCase {
  final AbacusGameRepository repository;
  SaveAbacusSettingUseCase(this.repository);

  Future<Either<Failure, bool>> call(AbacusSetting math) async {
    return await repository.saveAbacusSetting(
      math.playerId,
      math.numberColor,
      math.backgroundColor,
      math.name,
      math.operator,
      math.level,
      math.sublevel,
      math.digit,
      math.speed,
      math.rangeEnum,
    );
  }
}
