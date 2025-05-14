import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/Shared.dart';
import '../../domain/domain.dart';


class HomeState {
  final String playerName;
  final String error;
  final Player? lastPlayer;
  final bool hasCurrentPlayer;

  HomeState({this.playerName = '', this.error = '', this.lastPlayer, this.hasCurrentPlayer = false});

  HomeState copyWith({String? playerName, String? error, Player? lastPlayer, bool? hasCurrentPlayer}) {
    return HomeState(
      playerName: playerName ?? this.playerName,
      error: error ?? this.error,
      lastPlayer: lastPlayer ?? this.lastPlayer,
      hasCurrentPlayer: hasCurrentPlayer ?? this.hasCurrentPlayer,
    );
  }

  HomeState clearCurrentPlayer({bool? hasCurrentPlayer}) {
    return HomeState(hasCurrentPlayer: hasCurrentPlayer ?? false);
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final SavePlayerUseCase savePlayerUseCase = Modular.get<SavePlayerUseCase>();
  final GetLastPlayerUseCase getLastPlayerUseCase = Modular.get<GetLastPlayerUseCase>();
  final GetLastPlayerByIdUseCase getLastPlayerByIdUseCase = Modular.get<GetLastPlayerByIdUseCase>();

  final StreamController<bool> _loadingController = StreamController<bool>();
  bool _loading = false;

  Stream<bool> get loadingStream => _loadingController.stream;
  
  final TextEditingController nameController = TextEditingController();

  void setLoading(bool loading) {
    _loading = loading;
    _loadingController.add(loading);
  }

  Future<bool> savePlayer() async {
    if (_loading) return false;
    setLoading(true);
    final result = await savePlayerUseCase.call(nameController.text);
    result.fold((l) => emit(state.copyWith(error: l.message)), (r) {
      nameController.clear();
      emit(state.copyWith(error: ''));
    });
    setLoading(false);
    return result.isRight();
  }

  Future<Player?> getLastPlayer() async {
    if (_loading) return null;
    setLoading(true);
    final result = await getLastPlayerUseCase.call();
    setLoading(false);
    return result.fold((l) {
      emit(state.copyWith(error: l.message));
      return null;
    }, (r) {
      emit(state.copyWith(error: '', lastPlayer: r, hasCurrentPlayer: true));
      return r;
    });
  }

  void clearPlayer() {
    final hasCurrentPlayer = state.hasCurrentPlayer;
    emit(state.clearCurrentPlayer(hasCurrentPlayer: hasCurrentPlayer));
  }
  
  Future<Player?> getLastPlayerById(int playerId) async {
     if (_loading) return null;
    setLoading(true);
    final result = await getLastPlayerByIdUseCase.call(playerId);
    setLoading(false);
    return result.fold((l) {
      emit(state.copyWith(error: l.message));
      return null;
    }, (r) {
      emit(state.copyWith(error: '', lastPlayer: r, hasCurrentPlayer: true));
      return r;
    });
  }
}
