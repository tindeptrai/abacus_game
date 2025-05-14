import 'package:flutter_modular/flutter_modular.dart';

import '../../../modular/route.dart';
import '../home.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    bindsCubit(i);
  }

  @override
  void routes(r) {
    r.child(AppRouteConstants.defaultRoute, child: (context) => const HomeScreen());
    r.child(AppRouteConstants.settingsRoute, child: (context) => const SettingsScreen());
  }

  void bindsCubit(Injector i) {
    i.add<HomeCubit>(HomeCubit.new);
  }
}

