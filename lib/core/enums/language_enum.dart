import 'package:flutter/material.dart';

enum LanguageEnum {
  en(Locale('en'), 'English'),
  vi(Locale('vi'), 'Tiếng Việt'),
  ja(Locale('ja'), '日本語');

  final Locale locale;
  final String displayName;
  const LanguageEnum(this.locale, this.displayName);
} 