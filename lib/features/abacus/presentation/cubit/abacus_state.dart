import 'package:equatable/equatable.dart';

import '../../abacus.dart';


class AbacusState extends Equatable {
  final List<SquareModel>? shapes;
  final List<TopicModel>? numbers;
  final String result;
  final int hearts;
  final String playerName;
  final int index;

  const AbacusState({
    this.shapes,
    this.numbers,
    this.result = "0",
    this.hearts = 0,
    this.playerName = "",
    this.index = 0,
  });

  AbacusState copyWith({
    List<SquareModel>? shapes,
    List<TopicModel>? numbers,
    String? result,
    int? hearts,
    int? index,
    String? playerName,
  }) {
    return AbacusState(
      shapes: shapes ?? this.shapes,
      numbers: numbers ?? this.numbers,
      result: result ?? this.result,
      hearts: hearts ?? this.hearts,
      index: index ?? this.index,
      playerName: playerName ?? this.playerName,
    );
  }

  @override
  List<Object?> get props => [
        shapes.hashCode,
        numbers,
        result,
        hearts,
        playerName,
        index,
      ];
}
