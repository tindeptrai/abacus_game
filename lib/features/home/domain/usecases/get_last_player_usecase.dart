import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';

class GetLastPlayerUseCase {
  final SharedRepository sharedRepository;

  GetLastPlayerUseCase(this.sharedRepository);

  Future<Either<Failure, Player?>> call() async {
    return await sharedRepository.getLastPlayer();
  }
}
