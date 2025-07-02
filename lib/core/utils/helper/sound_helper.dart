import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../features/features.dart';

class SoundHelper {
  SoundHelper._constructor();
  static final SoundHelper _instance = SoundHelper._constructor();
  factory SoundHelper() => _instance;

  static const Map<String, String> map = {
    "0": "00.wav",
    "1": "01.wav", 
    "2": "02.wav",
    "3": "03.wav",
    "4": "04.wav",
    "5": "05.wav",
    "6": "06.wav",
    "7": "07.wav",
    "8": "08.wav",
    "9": "09.wav",
    "10": "010.wav",
    "BACK": "BACK.wav",
    "BLANK": "BLANK.wav",
    "": "BLANK.wav",
    "CHECK": "CHECK.wav",
    "DELETE": "DELETE.wav",
    "DRAFT": "DRAFT.wav",
    "HELP": "HELP.wav",
    "HOME": "HOME.wav",
    "PLAYERNAME": "PLAYERNAME.wav",
    "RESET": "RESET.wav",
    "SoFiAbacusGame": "SoFiAbacusGame.wav",
    "SoFiMentalMathGame": "SoFiMentalMathGame.wav",
    "SoFiSuRuGame": "SoFiSuRuGame.wav",
    "UNDO": "UNDO.wav",
    "TICK": "TICK.wav",
    "321": "321.wav",
    "Do": "Do.wav",
    "AnswerCorrect": "AnswerCorrect.wav",
  };

  final AudioPlayer _audioPlayer = AudioPlayer();
  var _isActive = true;


  String getSoundFile({
    required String action,
    required BuildContext context,
  }) {
    final appCubit = Modular.get<AppCubit>();
    final folder = appCubit.state.sound.nameFolder;
    final url = map[action];
    if (url == null) return "";
    final currentLocale = Localizations.localeOf(context);
    return "sound/$currentLocale/$folder/$url";
  }

  bool get isPlaying => 
    _audioPlayer.state != PlayerState.paused && 
    _audioPlayer.state != PlayerState.stopped;

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Lỗi khi dừng âm thanh: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause(); 
    } catch (e) {
      debugPrint('Lỗi khi tạm dừng âm thanh: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Lỗi khi tiếp tục phát: $e');
    }
  }

  Future<void> playSound({
    required String action,
    required BuildContext context,
  }) async {
    try {
      await stop();
      final fileName = getSoundFile(action: action, context: context);
      if (fileName.isEmpty) return;
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      _isActive = false;
      debugPrint('Lỗi phát âm thanh: $e');
    }
  }

  Future<void> playInLoop(BuildContext context) async {
    _isActive = true;
    for (var i = 0; i < 10 && _isActive; i++) {
      await playSound(action: i.toString(), context: context);
      if (!_isActive) break;
      await resume();
      await _audioPlayer.onPlayerComplete.first;
    }
  }

  Future<void> playSoundPiano({
    required int digit,
    required int place,
  }) async {
    try {
      await stop();
      final fileName = getWavFileName(digit, place);
      if (fileName.isEmpty) return;
      await _audioPlayer.play(AssetSource("sound/PianoSound/$fileName"));
    } catch (e) {
      debugPrint('Lỗi phát âm thanh piano: $e');
    }
  }

  void stopPlayback() => _isActive = false;

  void dispose() => _audioPlayer.dispose();

  /// Trả về tên file wav theo quy luật map số và hàng.
  /// [digit] là số (từ 5 đến 0)
  /// [place] là hàng (0: đơn vị, 1: chục, 2: trăm, ...)
  String getWavFileName(int digit, int place) {
    if (digit < 0 || digit > 5) throw ArgumentError('digit phải từ 0 đến 5');
    if (place < 0) throw ArgumentError('place phải >= 0');
    // Công thức: fileIndex = 19 + place * 6 + (5 - digit)
    int fileIndex = 19 + place * 6 + (5 - digit);
    if (fileIndex > 88) throw ArgumentError('fileIndex vượt quá 88');
    return '$fileIndex.wav';
  }
}