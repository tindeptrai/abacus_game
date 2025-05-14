import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../features/features.dart';
import '../../shared/Shared.dart';

class HiveService {
  static Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    final saveDir = Directory(path.join(appDir.path, 'sofi_games'));

    if (!saveDir.existsSync()) {
      saveDir.createSync();
    }

    await Hive.initFlutter(saveDir.path);

    // Register adapters
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PlayerModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AbacusSettingModelAdapter(), override: true);
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AbacusGameStateModelAdapter(), override: true);
    }
  }

  static Future<void> clearAndReinitialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory('${appDir.path}/hive');

    if (hiveDir.existsSync()) {
      await hiveDir.delete(recursive: true);
    }

    await Hive.deleteFromDisk();
    await init();
  }
}
