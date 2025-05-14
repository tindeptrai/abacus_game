import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../widgets/font_selector.dart';

// Định nghĩa trạng thái
class AppState extends Equatable {
  final FontFamilyEnum fontModel;
  final LanguageEnum currentLanguage;
  final VoiceEnum  sound;

  const AppState({required this.fontModel, required this.currentLanguage, required this.sound});

  @override
  List<Object> get props => [fontModel, currentLanguage, sound];

  AppState copyWith({FontFamilyEnum? fontModel, LanguageEnum? currentLanguage, VoiceEnum? sound}) {
    return AppState(
      fontModel: fontModel ?? this.fontModel,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      sound: sound ?? this.sound,
    );
  }
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState(fontModel: FontFamilyEnum.sofiFunNumber, currentLanguage: LanguageEnum.en,  sound: VoiceEnum.kid)) {
    _loadFontFamily();
    _loadCurrentLanguage();
    _loadSound();
  }

  Future<void> changeFont(FontFamilyEnum fontModel) async {
    emit(state.copyWith(fontModel: fontModel));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', fontModel.name);
  }


  Future<void> changeSound(VoiceEnum sound) async {
    emit(state.copyWith(sound: sound));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sound', sound.name);
  }


  Future<void> changeLanguage(LanguageEnum currentLanguage) async {
    emit(state.copyWith(currentLanguage: currentLanguage));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', currentLanguage.name);
  }

  Future<void> _loadFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    final fontFamily = prefs.getString('fontFamily') ?? FontFamilyEnum.sofiFunNumber.name;
    emit(state.copyWith(fontModel: FontFamilyEnum.values.firstWhere((e) => e.name == fontFamily, orElse: () => FontFamilyEnum.sofiFunNumber)));
  }

  Future<void> _loadCurrentLanguage() async {
    Locale systemLocale = PlatformDispatcher.instance.locale;
    final languageEnum = LanguageEnum.values.firstWhere((e) => e.locale.languageCode == systemLocale.languageCode, orElse: () => LanguageEnum.en);
    final prefs = await SharedPreferences.getInstance();
    final currentLanguage = prefs.getString('language') ?? languageEnum.name;
    emit(state.copyWith(currentLanguage: LanguageEnum.values.firstWhere((e) => e.name == currentLanguage)));
  }

  Future<void> _loadSound() async {
    final prefs = await SharedPreferences.getInstance();
    final currentSound = prefs.getString('sound') ?? VoiceEnum.kid.name;
    emit(state.copyWith(sound: VoiceEnum.values.firstWhere((e) => e.name == currentSound)));
  }


}
