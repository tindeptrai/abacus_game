import 'package:abacus_game/core/core.dart';

extension DoubleExtensions on double {
  BigInt toBigInt() {
    BigInt defaultNumber = BigInt.parse('1');
    return BigInt.tryParse(toString().intFormatNumber()) ?? defaultNumber ; // Làm tròn trước khi chuyển
  }
}
