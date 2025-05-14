
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../../modular/route.dart';
import '../../../features.dart';

class SettingGameCubit extends BaseSofiFunCubit<SettingGameState> {
  SettingGameCubit() : super(SettingGameState(level: LevelEntities(level: 1, subLevel: 0)));

  final UpdatePlayerUseCase updatePlayerUseCase = Modular.get<UpdatePlayerUseCase>();
  final GetLastPlayerUseCase getLastPlayerUseCase = Modular.get<GetLastPlayerUseCase>();


  final GetAbacusSettingByNameUseCase getAbacusSettingByNameUseCase = Modular.get();
  final SaveAbacusSettingUseCase saveAbacusSettingUseCase = Modular.get();

  Future<void> pushToAbacusGame() async {
    final player = await getLastPlayer();
    if (player != null) {
      math = MathArg(player: player);
    }
    Modular.to.pushNamed(
      AppRouteConstants.abacusGameFullRoute,
      arguments: math
        ..operator = state.operator
        ..level = state.level
        ..speed = state.speed
        ..numberRange = state.rangeEnum
        ..digit = state.digit,
    );
  }

  Future<void> saveMathSetting() async {
    final AbacusSetting mathSetting = AbacusSetting(
      backgroundColor: state.backgroundColor,
      numberColor: state.numberColor,
      name: math.player.name,
      operator: state.operator.value,
      level: state.level.level,
      sublevel: state.level.subLevel,
      digit: state.digit,
      speed: state.speed,
      rangeEnum: state.rangeEnum.value,
      playerId: math.player.id,
    );
    await saveAbacusSettingUseCase.call(mathSetting);
  }

  Future<void> initData() async {
    final rs = await getAbacusSettingByNameUseCase.call(math.player.id);
    rs.fold((l) {}, (r) {
      var operation = Operator.values.firstWhere((e) => e.value == (r?.operator ?? 1));
      var level = LevelEntities(level: r?.level ?? 1, subLevel: r?.sublevel ?? 0);
      var rangeEnum = NumberRangeEnum.values.firstWhere((e) => e.value == r?.rangeEnum);
      emit(
        state.copyWith(
          numberColor: r?.numberColor,
          backgroundColor: r?.backgroundColor,
          level: level,
          digit: r?.digit,
          speed: r?.speed,
          operator: operation,
          rangeEnum: rangeEnum,
        ),
      );
    });
  }
  late MathArg math;

  void onChangeLevel(LevelEntities level) {
    emit(state.copyWith(level: level));
    saveMathSetting();
  }



  void onChangeOperation (Operator? op){
    var digit = state.digit;
    var disableDigit = state.disableDigit;
    var level = state.level;
    if (op == Operator.multiplication || op == Operator.division) {
      digit = 2;
      disableDigit = true;
      level = LevelEntities(level: level.level, subLevel: 1);
    } else {
      disableDigit = false;
      level = LevelEntities(level: level.level, subLevel: 0);
    }
    emit(state.copyWith(operator: op, digit: digit, disableDigit: disableDigit, level: level),);
    saveMathSetting();
  }

  void onChangeDigitCount (int digit){
    emit(state.copyWith(digit: digit));
    saveMathSetting();
  }

  void onChangeSpeed (double? speed){
    emit(state.copyWith(speed: speed));
    saveMathSetting();
  }

  void onChangeRange(NumberRangeEnum? range){
    emit(state.copyWith(rangeEnum: range));
    saveMathSetting();
  }

  void onChangeNumberColor(String color){
    emit(state.copyWith(numberColor: color));
    saveMathSetting();
  }

  void onChangeBackGroundColor(String color){
    emit(state.copyWith(backgroundColor: color));
    saveMathSetting();
  }


  Future<Player?> getLastPlayer() async {
    final result = await getLastPlayerUseCase.call();
    return result.fold((l) {
      return null;
    }, (r) {
      return r;
    });
  }
}
