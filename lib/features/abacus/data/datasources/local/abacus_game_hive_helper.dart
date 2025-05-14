import 'package:hive/hive.dart';

import '../../../../../shared/Shared.dart';
import '../../../domain/domain.dart';
import '../../data.dart';
import '../../models/models.dart';

class AbacusGameHiveHelper {
  static const String gameStatesBoxName = 'abacus_game_states';
  static const String abacusSettingsBoxName = 'abacus_setting';

  AbacusGameHiveHelper();


  Future<void> _saveGameState(AbacusGameState state) async {
    if (!Hive.isBoxOpen(gameStatesBoxName)) {
      await Hive.openBox<AbacusGameStateModel>(gameStatesBoxName);
    }
    final box = Hive.box<AbacusGameStateModel>(gameStatesBoxName);
    final gameStateModel = AbacusGameStateModel.fromEntity(state);
    await box.add(gameStateModel);
  }

  Future<bool> updateGameState(AbacusGameState state) async {
    if (!Hive.isBoxOpen(gameStatesBoxName)) {
      await Hive.openBox<AbacusGameStateModel>(gameStatesBoxName);
    }
    final box = Hive.box<AbacusGameStateModel>(gameStatesBoxName);
    // Find player index by id
    final gameStateIndex = box.values.toList().indexWhere(
            (p) => p.playerId == p.playerId
    );

    if (gameStateIndex == -1) {
      await _saveGameState(state);
      return true;
    } else {
      final gameStateModel = AbacusGameStateModel.fromEntity(state);
      await box.putAt(gameStateIndex, gameStateModel);
      return true;
    }
  }

  Future<AbacusGameState?> getLastGameByPlayerIdAndGameName(int playerId, String gameName) async {
    if (!Hive.isBoxOpen(gameStatesBoxName)) {
      await Hive.openBox<AbacusGameStateModel?>(gameStatesBoxName);
    }
    final box = Hive.box<AbacusGameStateModel?>(gameStatesBoxName);
    final gameStateModel = box.values.lastWhere(
          (model) => model?.playerId == playerId && model?.gameName == gameName,
      orElse: () => null,
    );
    return gameStateModel?.toEntity();
  }

  Future<AbacusSetting?> getAbacusSettingByPlayerId(int playerId) async {
    if (!Hive.isBoxOpen(abacusSettingsBoxName)) {
      await Hive.openBox<AbacusSettingModel?>(abacusSettingsBoxName);
    }
    final box = Hive.box<AbacusSettingModel?>(abacusSettingsBoxName);
    final abacusSettingModel = box.values.lastWhere(
          (model) => model?.playerId == playerId,
      orElse: () => null,
    );
    return abacusSettingModel?.toEntity();
  }

  Future<void> _saveAbacusSetting(AbacusSetting Abacus) async {
    if (!Hive.isBoxOpen(abacusSettingsBoxName)) {
      await Hive.openBox<AbacusSettingModel?>(abacusSettingsBoxName);
    }
    final box = Hive.box<AbacusSettingModel?>(abacusSettingsBoxName);
    box.clear();
    final abacusSettingModel = AbacusSettingModel.fromEntity(Abacus);
    await box.add(abacusSettingModel);
  }

  Future<bool> updateAbacusSetting(AbacusSetting abacus) async {
    try {
      if (!Hive.isBoxOpen(abacusSettingsBoxName)) {
        await Hive.openBox<AbacusSettingModel?>(abacusSettingsBoxName);
      }
      final box = Hive.box<AbacusSettingModel?>(abacusSettingsBoxName);
      final abacusSettingIndex = box.values.toList().indexWhere(
            (p) => p?.playerId == p?.playerId,
      );

      if (abacusSettingIndex == -1) {
        await _saveAbacusSetting(abacus);
        return true;
      } else {
        final abacusSettingModel = AbacusSettingModel.fromEntity(abacus);
        await box.putAt(abacusSettingIndex, abacusSettingModel);
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
