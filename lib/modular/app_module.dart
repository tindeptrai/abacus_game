import 'package:flutter_modular/flutter_modular.dart';
import '../features/features.dart';
import '../shared/shared.dart';
import 'route.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AppCubit>(AppCubit.new);
    _bindRepositories(i);
    _bindUseCases(i);
  }

  @override
  void routes(r) {
    r.child(AppRouteConstants.defaultRoute, child: (context) => const SplashScreen());
    r.module(AppRouteConstants.homeRoute, module: HomeModule());
    r.module(AppRouteConstants.abacusRoute, module: AbacusModule());
  }

  void _bindRepositories(Injector i) {
    i.addSingleton<AbacusGameHiveHelper>(AbacusGameHiveHelper.new);
    i.add<AbacusGameRepository>(AbacusGameRepositoryImpl.new);
    i.addSingleton<SharedHiveHelper>(SharedHiveHelper.new);
    i.addSingleton<SharedRepository>(SharedRepositoryImpl.new);

  }

  void _bindUseCases(Injector i) {
    i.add<SavePlayerUseCase>(SavePlayerUseCase.new);
    i.add<UpdatePlayerUseCase>(UpdatePlayerUseCase.new);
    i.add<GetLastPlayerUseCase>(GetLastPlayerUseCase.new);
    i.add<GetAbacusSettingByNameUseCase>(GetAbacusSettingByNameUseCase.new);
    i.add<SaveAbacusSettingUseCase>(SaveAbacusSettingUseCase.new);
    i.add<GetLastPlayerByIdUseCase>(GetLastPlayerByIdUseCase.new);
  }
}