import 'package:flutter_modular/flutter_modular.dart';

import '../../../modular/route.dart';
import '../abacus.dart';


class AbacusModule extends Module {
  @override
  void binds(Injector i) {
    i.add<AbacusCubit>(AbacusCubit.new);
    i.add<AbacusSettingsCubit>(AbacusSettingsCubit.new);

  }

  @override
  void routes(r) {
    r.child(AppRouteConstants.defaultRoute, child: (context) => AbacusSettingsScreen(Modular.get<AbacusSettingsCubit>()));
    r.child(AppRouteConstants.abacusGameScreenRoute, child: (context) => AbacusScreen(Modular.get()));
  }
}
