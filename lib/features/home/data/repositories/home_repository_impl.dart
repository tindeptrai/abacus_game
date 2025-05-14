// import 'package:dartz/dartz.dart';
//
// import '../../../core/core.dart';
// import '../../../domain/domain.dart';
// import '../datasources/local/home_hive_helper.dart';
//
// class HomeRepositoryImpl implements HomeRepository {
//   final HomeHiveHelper hiveHelper;
//
//   HomeRepositoryImpl({required this.hiveHelper});
//
//   @override
//   Future<Either<Failure, Player?>> getLastPlayer() async {
//     final player = await hiveHelper.getLastPlayer();
//     if (player == null) {
//       return const Left(DatabaseFailure('No player found'));
//     }
//     return Right(player);
//   }
//
//   @override
//   Future<Either<Failure, bool>> savePlayer(Player player) async {
//     try {
//       await hiveHelper.savePlayer(player);
//       return const Right(true);
//     } catch (e) {
//       return const Left(DatabaseFailure('Failed to save player'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, bool>> saveMathSetting(MathSetting math) async {
//     try {
//       await hiveHelper.saveMathSetting(math);
//       return const Right(true);
//     } catch (e) {
//       return const Left(DatabaseFailure('Failed to save player'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, Player?>> getLastPlayerByName(String name) async {
//     final player = await hiveHelper.getLastPlayerByName(name);
//     if (player == null) {
//       return const Left(DatabaseFailure('No player found'));
//     }
//     return Right(player);
//   }
//
//   @override
//   Future<Either<Failure, MathSetting?>> getMathSettingByName(String name) async {
//     final player = await hiveHelper.getMathSettingByName(name);
//     if (player == null) {
//       return const Left(DatabaseFailure('No player found'));
//     }
//     return Right(player);
//   }
// }
