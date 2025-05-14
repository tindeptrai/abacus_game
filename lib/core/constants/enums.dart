import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GameType {
  math,
  sudoku,
}

enum KeyboardMode {
  left(name: "left", value: 1, crossAxisAlignment: CrossAxisAlignment.end),
  right(name: "right", value: 2, crossAxisAlignment: CrossAxisAlignment.start),
  center(name: "center", value: 3, crossAxisAlignment: CrossAxisAlignment.center);

  final String name;
  final int value;
  final CrossAxisAlignment crossAxisAlignment;

  const KeyboardMode({
    required this.name,
    required this.value,
    required this.crossAxisAlignment,
  });
}



enum Operator {
  addition(name: "Cộng", value: 1, display: "+"),
  subtraction(name: " Cộng trừ", value: 2, display: ""),
  multiplication (name: "Nhân", value: 3, display: "x"),
  division (name: "Chia", value: 4, display: '÷');

  final String name;
  final int value;
  final String display;

  const Operator({
    required this.name,
    required this.value,
    required this.display,
  });

  String localized(AppLocalizations localizations) {
    switch (this) {
      case Operator.addition:
        return localizations.addition;
      case Operator.subtraction:
        return localizations.addition_subtraction;
      case Operator.multiplication:
        return localizations.multiplication;
      case Operator.division:
        return localizations.division;
    }
  }
}


enum VoiceEnum {
  kid(title: "Trẻ em", nameFolder: "Kids"),
  woman(title: "Nữ", nameFolder: "Woman"),
  man (title: "Nam",  nameFolder: "Man"),
  off (title: "Tắt",  nameFolder: "");


  final String title;
  final String nameFolder;
  const VoiceEnum({required this.title, required this.nameFolder});

  String localized(AppLocalizations localizations) {
    switch (this) {
      case VoiceEnum.kid:
        return localizations.child;
      case VoiceEnum.woman:
        return localizations.female;
      case VoiceEnum.man:
        return localizations.male;
      case VoiceEnum.off:
        return localizations.off;
    }
  }
}


enum NumberRangeEnum {
  low(title: "Từ 0 đến 5", range: [0,5], value: 1),
  high(title: "Từ 5 đến 9", range: [5,9], value: 2),
  all (title: "Từ 0 đến 9",  range: [0,9], value: 3);


  final String title;
  final int value;
  final List<int> range;
  const NumberRangeEnum({required this.title, required this.range, required this.value});

  String localized(AppLocalizations localizations) {
    switch (this) {
      case NumberRangeEnum.low:
        return localizations.rangeNumber(0,5);
      case NumberRangeEnum.high:
        return localizations.rangeNumber(5,9);
      case NumberRangeEnum.all:
        return localizations.rangeNumber(0,9);
    }
  }
}


enum LineSegment {
  A(value: 'A2'), // cạnh trên
  B(value: 'A1'), // cạnh phải
  C(value: 'A3'), // cạnh dưới
  D(value: 'A4'), // cạnh trái
  E(value: 'A5'), // đường chéo 1
  F(value: 'A6'); // đường chéo 2

  final String value;

  const LineSegment({required this.value});
}

Map<Set<String>, int> mapping = {
  {'A1'}: 1,
  {'A2', 'A1'}: 2,
  {'A3', 'A2', 'A1'}: 3,
  {'A4', 'A3', 'A2', 'A1'}: 4,
  {'A5'}: 5,
  {'A1', 'A5'}: 6,
  {'A2', 'A1', 'A5'}: 7,
  {'A3', 'A2', 'A1', 'A5'}: 8,
  {'A5', 'A4', 'A3', 'A2', 'A1'}: 9,
  {'A6', 'A5'}: 0,
};

// Thêm extension để map màu sắc
extension LineSegmentColor on LineSegment {
  Color get color {
    switch (this) {
      case LineSegment.A:
        return Colors.blue;
      case LineSegment.B:
        return Colors.orange;
      case LineSegment.C:
        return Colors.purple;
      case LineSegment.D:
        return Colors.teal;
      case LineSegment.E:
        return Colors.green;
      case LineSegment.F:
        return Colors.indigo;
    }
  }
}