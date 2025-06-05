import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';
import 'abacus_state.dart';

class SquareModel {
  List<LineSegment> data;
  SquareModel({required this.data});

  SquareModel cloneTo() {
    return SquareModel(data: List.from(data));
  }
}

class AbacusCubit extends Cubit<AbacusState> {
  AbacusCubit() : super(AbacusState());
  int length = 6;

  NumberRangeEnum range =  NumberRangeEnum.all;

  final UpdatePlayerUseCase updatePlayerUseCase = Modular.get<UpdatePlayerUseCase>();



  LevelEntities? levelEntities;

  late Player playerProfile;

  Operator operator = Operator.addition;

  int digit = 5;

  List<BigInt> generateNumbers() {
    var list = <BigInt>[];
    var level = levelEntities?.level ?? 1;
    var subLevel = levelEntities?.subLevel ?? 1;
    final random = Random();

    /// case /, x
    var subLevel2 = subLevel;
    if (level != 1) {
      subLevel2 = subLevel + level - 1;
    }

    final maxNumber1 = pow(10, subLevel2).toInt() - 1;
    final minNumber1 = pow(10,  subLevel2 - 1).toInt();

    final maxNumber2 = pow(10, level).toInt() - 1;
    final minNumber2 = pow(10, level - 1).toInt();

    switch (operator) {
      case Operator.addition:
        List<BigInt> numbers = List.generate(digit,
                (_) => generateNumber(level));
        list = numbers;
        break;
      case Operator.subtraction:
        List<BigInt> numbers = List.generate(
            digit,
                (e) {
              final isPositive = e.isEven;
              final number = generateNumber(level);
              return isPositive ? number : -number;
            });
        if (level == 1 &&  digit == 2 ) {
          var number0 = numbers[0].toDouble();
          var number1 = numbers[1].toDouble();
          if (number0 + number1< 0) {
            number0 = - number0;
            number1 = - number1;
          }
          numbers[0] = number0.toBigInt();
          numbers[1] = number1.toBigInt();
        }
        list = numbers;
        break;
      case Operator.multiplication:
        final number1 = doubleInRange(random, minNumber1, maxNumber1).roundToDouble();
        final number2 = doubleInRange(random, minNumber2, maxNumber2).roundToDouble();
        list = [number1.toBigInt(), number2.toBigInt()];
        break;
      case Operator.division:
        final a4 = doubleInRange(random, minNumber2, maxNumber2).roundToDouble().toBigInt();
        final b5 = doubleInRange(random, minNumber1, maxNumber1).roundToDouble().toBigInt();

        final  c = a4 * b5;
        list = [c, a4];
        break;
    }
    return list;
  }

  void initData({
    LevelEntities? level,
    Operator? operation,
    NumberRangeEnum? rangeInput,
    Player? player,
  }) {
    levelEntities = level;
    operator = operation ?? Operator.addition;
    range = rangeInput ?? NumberRangeEnum.all;
    setPlayerName(player ?? playerProfile);
    resetGame();
  }

  void resetGame(){
    final numbers = generateNumbers();
    BigInt result = getResult(numbers: numbers);
    length = result.toString().length > 5 ? result.toString().length : 5;
    emit(state.copyWith(numbers: numbers));
    resetShapes();
  }

  void resetShapes() {
    List<SquareModel> shapes = List.generate(length, (index) {
      // return SquareModel(data: [LineSegment.E, LineSegment.F]);
      return SquareModel(data: []);
    });
    emit(state.copyWith(shapes: shapes));
  }



  BigInt generateNumber(int level) {
    Random random = Random();
    String numberStr = '';
    final min = range.range[0];
    final max = range.range[1];
    for (int i = 0; i < level; i++) {
      int digit ;
      if (i == 0) {
        digit = random.nextInt(max - min) + min + (min == 0 ? 1 : 0);
      } else {
        digit = random.nextInt(max - min + 1) + min;
      }
      numberStr += digit.toString();
    }

    return BigInt.tryParse(numberStr) ?? BigInt.parse('1');
  }

  Map<String, int> mapping = {
    'A1': 1,
    'A1,A2': 2,
    'A1,A2,A3': 3,
    'A1,A2,A3,A4': 4,
    'A5': 5,
    'A1,A5': 6,
    'A1,A2,A5': 7,
    'A1,A2,A3,A5': 8,
    'A1,A2,A3,A4,A5': 9,
    // 'A5,A6': 0,
  };


  void onChangeDataInShape(SquareModel shape, int index, List<LineSegment> segments) {
    List<SquareModel> shapes = state.shapes!;
    final oldShape = shapes[index].cloneTo();
    shape.data = segments;
    // Compare number of edges between old and new shape
    if (shape.data.isEmpty){
      shape = SquareModel(data: []);
    }
    else if (shape.data.length < oldShape.data.length) {
      // If new shape has fewer edges, find the minimum valid mapping value
      var keys = shape.data.map((e) => e.value).toList()..sort();
      
      // Find all valid combinations that can be formed with remaining segments
      var validCombinations = <String>[];
      for (var entry in mapping.entries) {
        final entries = entry.key.split(',');
        // Check if all segments in the combination are present in the current shape
        if (entries.every((element) => keys.contains(element))) {
          validCombinations.add(entry.key);
        }
      }

      if (validCombinations.isEmpty) {
        // If no valid combination found, set to empty
        shape = SquareModel(data: []);
      } else {
        // Find the combination with minimum value
        var maxValue = -1;
        var bestCombination = '';
        for (var combination in validCombinations) {
          var value = mapping[combination] ?? -1;
          if (value > maxValue) {
            maxValue = value;
            bestCombination = combination;
          }
        }
        
        // Convert best combination back to LineSegments
        shape = SquareModel(
          data: bestCombination.split(',').map((e) => 
            LineSegment.values.firstWhere((ls) => ls.value == e)
          ).toList()
        );
      }
    } else if (shape.data.length > oldShape.data.length) {
      // If new shape has more edges, find closest valid number
      var keys = shape.data.map((e) => e.value).toList()..sort();
      // Find valid combination with closest number of edges
      var bestMatch = ''; // Default to 0
      var bestDiff = 999;
      for (var entry in mapping.entries) {
        final entries = entry.key.split(',');
        final containsValue = keys.every((element) => entries.contains(element));
        if (!containsValue ) continue;
        var edgeCount = entries.length;
        var diff = (edgeCount - keys.length).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          bestMatch = entry.key;
        }
      }
      if (bestMatch == '') {
        shape = SquareModel(data: []);
      } else {
        // Convert best match back to LineSegments
        shape = SquareModel(
            data: bestMatch.split(',').map((e) => LineSegment.values.firstWhere((ls) => ls.value == e)).toList()
        );
      }
    }

    shapes[index] = shape.cloneTo();
    emit(state.copyWith(shapes: [...shapes]));
    convertShapeToTotalNumber();
  }

  void convertShapeToTotalNumber(){
    String numberStr = '';
    for (var element in state.shapes!) {
      var keys = element.data.map((e)=> e.value).toList();
      keys.sort();
      final keysStr = keys.join(',');
      var number = mapping[keysStr] ?? 0;
      numberStr += number.toString();
    }
    emit(state.copyWith(result: numberStr));
  }
  showError() {

  }


  void rePlay() {
    initData(level: levelEntities, operation: operator, rangeInput: range);
  }


  BigInt getResult({List<BigInt>? numbers}) {
    numbers ??= state.numbers;
    BigInt result = BigInt.parse('0');
    switch (operator) {
      case Operator.addition:
      case Operator.subtraction:
        result = numbers!.reduce((a, b) => a + b);
        break;
      case Operator.multiplication:
        var value1 = numbers![0];
        var value2 = numbers![1];
        result =  value1 * value2;
        break;
      case Operator.division:
        var value1 = numbers![0];
        var value2 = numbers[1];
        result =  value1 ~/ value2;
        break;
      default:
        result = BigInt.parse('0') ;
    }
    return result;
  }
  

  Future<(bool, BigInt?, BigInt?)> checkAnswer() async {
    BigInt result = getResult();
    var resultShow = BigInt.tryParse(result.toString().intFormatNumber());
    final userAnswer = BigInt.tryParse(state.result.toString().intFormatNumber());

    try {
      if (result.toString().intFormatNumber() == userAnswer.toString().intFormatNumber()) {
        int newHearts = state.hearts + (levelEntities?.level ?? 0);
        await saveHearts(newHearts);
        emit(state.copyWith(
          hearts: newHearts,
        ));
        return (true, resultShow, userAnswer);
      } else {
        return (false, resultShow, userAnswer);
      }
    } catch (e) {}
    return (false, resultShow, BigInt.parse('1'));
  }

  Future<void> saveHearts(int hearts) async {
    final player = playerProfile;
    await updatePlayerUseCase.call(player.copyWith(mathPoint: hearts));
  }

  void setPlayerName(Player player) {
    playerProfile = player;
    emit(state.copyWith(playerName: player.name, hearts: player.mathPoint));
  }

  double doubleInRange(Random source, num start, num end) =>
      (source.nextDouble() * (end - start) + start);

}