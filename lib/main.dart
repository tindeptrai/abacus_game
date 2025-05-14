import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/core.dart';
import 'modular/app_module.dart';
import 'app_widget.dart';
import 'modular/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.init();
  
  // Configure routes
  Modular.setInitialRoute(AppRouteConstants.defaultRoute);
  
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}