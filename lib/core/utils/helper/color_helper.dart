
import 'package:flutter/material.dart';
import 'dart:math';
class ColorHelper {
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse('0x$hex'));
  }

  static double luminance(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    double rLuminance = (r <= 0.03928) ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
    double gLuminance = (g <= 0.03928) ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
    double bLuminance = (b <= 0.03928) ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * rLuminance + 0.7152 * gLuminance + 0.0722 * bLuminance;
  }

  // Hàm tính tỷ lệ tương phản giữa hai màu
  static double contrastRatio(Color color1, Color color2) {
    double luminance1 = luminance(color1) + 0.05;
    double luminance2 = luminance(color2) + 0.05;

    return luminance1 > luminance2
        ? luminance1 / luminance2
        : luminance2 / luminance1;
  }

  // Hàm kiểm tra xem màu có phù hợp không (tỷ lệ tương phản >= 4.5:1)
  static bool isContrastGood(Color background, Color foreground) {
    final contrast = contrastRatio(background, foreground);
    final rs = contrast >= 3;
    return rs;
  }

}