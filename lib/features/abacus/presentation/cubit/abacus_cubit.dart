import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/core.dart';
import '../../../../shared/Shared.dart';
import '../../abacus.dart';
import 'abacus_state.dart';

/// Model đại diện cho một hình vuông với các đường chéo
class SquareModel {
  final List<LineSegment> data;
  
  const SquareModel({this.data = const []});

  SquareModel copyWith({List<LineSegment>? data}) {
    return SquareModel(data: data ?? this.data);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SquareModel && 
           listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}

/// Service class để xử lý logic mapping số
class NumberMappingService {
  static const Map<String, int> _mapping = {
    'A1': 1,
    'A1,A2': 2,
    'A1,A2,A3': 3,
    'A1,A2,A3,A4': 4,
    'A5': 5,
    'A1,A5': 6,
    'A1,A2,A5': 7,
    'A1,A2,A3,A5': 8,
    'A1,A2,A3,A4,A5': 9,
  };

  /// Chuyển đổi danh sách LineSegment thành số
  static int segmentsToNumber(List<LineSegment> segments) {
    final keys = segments.map((e) => e.value).toList()..sort();
    final keysStr = keys.join(',');
    return _mapping[keysStr] ?? 0;
  }

  /// Tìm combination tốt nhất từ các segments có sẵn
  static List<LineSegment> findBestCombination(List<LineSegment> segments) {
    if (segments.isEmpty) return [];
    
    final keys = segments.map((e) => e.value).toList()..sort();
    
    // Tìm tất cả combinations hợp lệ
    final validCombinations = <String>[];
    for (final entry in _mapping.entries) {
      final entries = entry.key.split(',');
      if (entries.every((element) => keys.contains(element))) {
        validCombinations.add(entry.key);
      }
    }

    if (validCombinations.isEmpty) return [];

    // Tìm combination có giá trị cao nhất
    String bestCombination = '';
    int maxValue = -1;
    
    for (final combination in validCombinations) {
      final value = _mapping[combination] ?? -1;
      if (value > maxValue) {
        maxValue = value;
        bestCombination = combination;
      }
    }

    return bestCombination.split(',').map((e) => 
      LineSegment.values.firstWhere((ls) => ls.value == e)
    ).toList();
  }

  /// Tìm combination gần nhất với số lượng segments
  static List<LineSegment> findClosestCombination(List<LineSegment> segments) {
    if (segments.isEmpty) return [];
    
    final keys = segments.map((e) => e.value).toList()..sort();
    String bestMatch = '';
    int bestDiff = 999;
    
    for (final entry in _mapping.entries) {
      final entries = entry.key.split(',');
      if (!keys.every((element) => entries.contains(element))) continue;
      
      final edgeCount = entries.length;
      final diff = (edgeCount - keys.length).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestMatch = entry.key;
      }
    }

    if (bestMatch.isEmpty) return [];

    return bestMatch.split(',').map((e) => 
      LineSegment.values.firstWhere((ls) => ls.value == e)
    ).toList();
  }
}

/// Service class để xử lý logic tạo số
class NumberGenerationService {
  static BigInt generateNumber(int level, NumberRangeEnum range) {
    final random = Random();
    String numberStr = '';
    final min = range.range[0];
    final max = range.range[1];
    
    for (int i = 0; i < level; i++) {
      int digit;
      if (i == 0) {
        digit = random.nextInt(max - min) + min + (min == 0 ? 1 : 0);
      } else {
        digit = random.nextInt(max - min + 1) + min;
      }
      numberStr += digit.toString();
    }

    return BigInt.tryParse(numberStr) ?? BigInt.parse('1');
  }

  static List<BigInt> generateNumbers({
    required int level,
    required int subLevel,
    required Operator operator,
    required NumberRangeEnum range,
    required int digit,
  }) {
    final random = Random();
    final list = <BigInt>[];

    // Tính toán subLevel cho phép nhân và chia
    final subLevel2 = level != 1 ? subLevel + level - 1 : subLevel;
    final maxNumber1 = pow(10, subLevel2).toInt() - 1;
    final minNumber1 = pow(10, subLevel2 - 1).toInt();
    final maxNumber2 = pow(10, level).toInt() - 1;
    final minNumber2 = pow(10, level - 1).toInt();

    switch (operator) {
      case Operator.addition:
        list.addAll(List.generate(digit, (_) => generateNumber(level, range)));
        break;
        
      case Operator.subtraction:
        final numbers = List.generate(digit, (e) {
          final isPositive = e.isEven;
          final number = generateNumber(level, range);
          return isPositive ? number : -number;
        });
        
        // Đảm bảo kết quả dương cho level 1 với 2 số
        if (level == 1 && digit == 2) {
          final number0 = numbers[0].toDouble();
          final number1 = numbers[1].toDouble();
          if (number0 + number1 < 0) {
            numbers[0] = (-number0).toBigInt();
            numbers[1] = (-number1).toBigInt();
          }
        }
        list.addAll(numbers);
        break;
        
      case Operator.multiplication:
        final number1 = _doubleInRange(random, minNumber1, maxNumber1).roundToDouble();
        final number2 = _doubleInRange(random, minNumber2, maxNumber2).roundToDouble();
        list.addAll([number1.toBigInt(), number2.toBigInt()]);
        break;
        
      case Operator.division:
        final a4 = _doubleInRange(random, minNumber2, maxNumber2).roundToDouble().toBigInt();
        final b5 = _doubleInRange(random, minNumber1, maxNumber1).roundToDouble().toBigInt();
        final c = a4 * b5;
        list.addAll([c, a4]);
        break;
    }
    
    return list;
  }

  static double _doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}

/// Service class để xử lý logic tính toán
class CalculationService {
  static BigInt calculateResult(List<BigInt> numbers, Operator operator) {
    switch (operator) {
      case Operator.addition:
      case Operator.subtraction:
        return numbers.reduce((a, b) => a + b);
      case Operator.multiplication:
        return numbers[0] * numbers[1];
      case Operator.division:
        return numbers[0] ~/ numbers[1];
      default:
        return BigInt.zero;
    }
  }
}

/// Cubit chính cho game Abacus
class AbacusCubit extends Cubit<AbacusState> {
  AbacusCubit() : super(AbacusState());

  // Dependencies
  final UpdatePlayerUseCase _updatePlayerUseCase = Modular.get<UpdatePlayerUseCase>();

  // Game state
  LevelEntities? _levelEntities;
  Player? _playerProfile;
  Operator _operator = Operator.addition;
  NumberRangeEnum _range = NumberRangeEnum.all;
  int _digit = 5;
  int _length = 6;

  // Getters
  LevelEntities? get levelEntities => _levelEntities;
  Player? get playerProfile => _playerProfile;
  Operator get operator => _operator;
  NumberRangeEnum get range => _range;
  int get digit => _digit;
  int get length => _length;

  /// Khởi tạo dữ liệu game
  void initData({
    LevelEntities? level,
    Operator? operation,
    NumberRangeEnum? rangeInput,
    Player? player,
  }) {
    _levelEntities = level;
    _operator = operation ?? Operator.addition;
    _range = rangeInput ?? NumberRangeEnum.all;
    _setPlayerName(player ?? _playerProfile!);
    resetGame();

  }

  /// Reset game về trạng thái ban đầu
  void resetGame() {
    final numbers = _generateNumbers();
    final result = CalculationService.calculateResult(numbers, _operator);
    _length = result.toString().length > 5 ? result.toString().length : 5;
    final topicNumbers = _convertBigIntToTopicModel(numbers);
    emit(state.copyWith(numbers: topicNumbers));
    _resetShapes();
  }
  /// Chuyển đổi danh sách BigInt thành danh sách TopicModel
  List<TopicModel> _convertBigIntToTopicModel(List<BigInt> numbers) {
    return numbers.map((number) => TopicModel(
      id: number,
      isHighlight: false,
    )).toList();
  }


  void onChangeIndex(int index) {
    emit(state.copyWith(index: index));
  }


  /// Reset tất cả shapes về trạng thái rỗng
  void _resetShapes() {
    final shapes = List.generate(_length, (index) => const SquareModel());
    emit(state.copyWith(shapes: shapes));
    _convertShapeToTotalNumber();
  }

  /// Tạo danh sách số cho game
  List<BigInt> _generateNumbers() {
    return NumberGenerationService.generateNumbers(
      level: _levelEntities?.level ?? 1,
      subLevel: _levelEntities?.subLevel ?? 1,
      operator: _operator,
      range: _range,
      digit: _digit,
    );
  }

  /// Xử lý thay đổi dữ liệu trong shape
  Future<void> onChangeDataInShape(SquareModel shape, int index, List<LineSegment> segments) async {
    final shapes = List<SquareModel>.from(state.shapes!);
    final oldShape = shapes[index];
    
    SquareModel newShape;
    
    if (segments.isEmpty) {
      newShape = const SquareModel();
    } else if (segments.length < oldShape.data.length) {
      // Nếu có ít segments hơn, tìm combination tốt nhất
      newShape = SquareModel(
        data: NumberMappingService.findBestCombination(segments)
      );
    } else if (segments.length > oldShape.data.length) {
      // Nếu có nhiều segments hơn, tìm combination gần nhất
      newShape = SquareModel(
        data: NumberMappingService.findClosestCombination(segments)
      );
    } else {
      // Số lượng segments giữ nguyên
      newShape = SquareModel(data: segments);
    }

    final number = NumberMappingService.segmentsToNumber(newShape.data);

    await SoundHelper().playSoundPiano(digit: number, place: shapes.length - index - 1);
    shapes[index] = newShape;
    emit(state.copyWith(shapes: shapes));
    _convertShapeToTotalNumber();
  }


  

  /// Chuyển đổi shapes thành số tổng
  void _convertShapeToTotalNumber() {
    final numberStr = state.shapes!
        .map((element) => NumberMappingService.segmentsToNumber(element.data))
        .join('');
    
    emit(state.copyWith(result: numberStr));
  }

  /// Replay game
  void rePlay() {
    resetGame();
  }

  /// Tính toán kết quả từ danh sách số
  BigInt getResult({List<TopicModel>? numbers}) {
    numbers ??= state.numbers;
    final bigIntNumbers = numbers!.map((e) => e.id).toList();
    return CalculationService.calculateResult(bigIntNumbers, _operator);
  }

  /// Kiểm tra đáp án
  Future<(bool, BigInt?, BigInt?)> checkAnswer() async {
    try {
      final result = getResult();
      final resultShow = BigInt.tryParse(result.toString().intFormatNumber());
      final userAnswer = BigInt.tryParse(state.result.toString().intFormatNumber());

      if (result.toString().intFormatNumber() == userAnswer.toString().intFormatNumber()) {
        final newHearts = state.hearts + (_levelEntities?.level ?? 0);
        await _saveHearts(newHearts);
        emit(state.copyWith(hearts: newHearts));
        return (true, resultShow, userAnswer);
      } else {
        return (false, resultShow, userAnswer);
      }
    } catch (e) {
      return (false, BigInt.zero, BigInt.parse('1'));
    }
  }

  /// Lưu hearts
  Future<void> _saveHearts(int hearts) async {
    if (_playerProfile != null) {
      final player = _playerProfile!;
      await _updatePlayerUseCase.call(player.copyWith(mathPoint: hearts));
    }
  }

  /// Set tên player
  void _setPlayerName(Player player) {
    _playerProfile = player;
    emit(state.copyWith(
      playerName: player.name,
      hearts: player.mathPoint,
    ));
  }
}