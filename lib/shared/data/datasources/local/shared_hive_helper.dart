import 'package:hive/hive.dart';

import '../../../domain/domain.dart';
import '../../models/models.dart';

class SharedHiveHelper {
  static const String playersBoxName = 'players';

  SharedHiveHelper();

  int _getNextId(Box<PlayerModel?> box) {
    final lastId = box.values.lastOrNull?.id ?? 0;
    return lastId + 1;
  }

  Future<Player> addPlayer(String playerName) async {
    if (!Hive.isBoxOpen(playersBoxName)) {
      await Hive.openBox<PlayerModel?>(playersBoxName);
    }
    final box = Hive.box<PlayerModel?>(playersBoxName);
    final existingPlayer = box.values.firstWhere(
      (p) => p?.name.toLowerCase() == playerName.toLowerCase(),
      orElse: () => null,
    );

    if (existingPlayer != null) {
      final indexPlayer = box.values.toList().indexWhere((p) => p?.id == existingPlayer.id);
      await box.deleteAt(indexPlayer);
      await box.add(existingPlayer);
      return existingPlayer.toEntity();
    }

    int nextId = _getNextId(box);


    final playerModel = PlayerModel(
      id: nextId,
      name: playerName,
      suruPoint: 5,
      abacusPoint: 5,
    );

    await box.add(playerModel);
    return playerModel.toEntity();
  }

  Future<bool> updatePlayer(int playerId, {int? suruPoint, int? abacusPoint}) async {
    if (!Hive.isBoxOpen(playersBoxName)) {
      await Hive.openBox<PlayerModel?>(playersBoxName);
    }
    final box = Hive.box<PlayerModel?>(playersBoxName);

    // Check if player with same name exists
    final currentIndex = box.values.toList().indexWhere(
      (p) => p?.id == playerId,
    );

    if (currentIndex != -1) {
      final playerModel = PlayerModel(
        id: playerId,
        name: box.values.toList()[currentIndex]!.name,
        suruPoint: suruPoint ?? box.values.toList()[currentIndex]!.suruPoint,
        abacusPoint: abacusPoint ?? box.values.toList()[currentIndex]!.abacusPoint,
      );

      await box.putAt(currentIndex, playerModel);
      return true;
    }

    return false;
  }

  Future<Player?> getLastedPlayer() async {
    if (!Hive.isBoxOpen(playersBoxName)) {
      await Hive.openBox<PlayerModel?>(playersBoxName);
    }
    final box = Hive.box<PlayerModel?>(playersBoxName);
    final playerModel = box.values.lastWhere(
      (p) => p?.id != null,
      orElse: () => null,
    );
    return playerModel?.toEntity();
  }

  Future<Player?> getPlayerByName(String playerName) async {
    if (!Hive.isBoxOpen(playersBoxName)) {
      await Hive.openBox<PlayerModel?>(playersBoxName);
    }
    final box = Hive.box<PlayerModel?>(playersBoxName);

    final playerModel = box.values.firstWhere(
      (p) => p?.name.toLowerCase() == playerName.toLowerCase(),
      orElse: () => null,
    );
    return playerModel?.toEntity();
  }

  Future<List<Player>> getAllPlayers() async {
    if (!Hive.isBoxOpen(playersBoxName)) {
      await Hive.openBox<PlayerModel>(playersBoxName);
    }
    final box = Hive.box<PlayerModel>(playersBoxName);
    return box.values.map((model) => model.toEntity()).toList();
  }

  Future<Player?> getPlayerById(int playerId) async {
    if (!Hive.isBoxOpen(playersBoxName)) {
      await Hive.openBox<PlayerModel?>(playersBoxName);
    }
    final box = Hive.box<PlayerModel?>(playersBoxName);
    final playerModel = box.values.firstWhere(
      (p) => p?.id == playerId,
      orElse: () => null,
    );
    return playerModel?.toEntity();
  }
}
