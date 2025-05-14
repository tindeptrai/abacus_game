import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../features/features.dart';

class SoundHelper {
  SoundHelper._constructor();
  static final SoundHelper _instance = SoundHelper._constructor();
  factory SoundHelper() => _instance;

  static final Map<String, String> map = {
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
  })  {
    final appCubit = Modular.get<AppCubit>();
    final folder = appCubit.state.sound.nameFolder;
    final url = map[action];
    if(url == null) return "";
    final currentLocale = Localizations.localeOf(context);
    return "sound/$currentLocale/$folder/$url";
  }
  bool isPlaying() {
    return _audioPlayer.state != PlayerState.paused || _audioPlayer.state != PlayerState.stopped;
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> playSound({
    required String action,
    required BuildContext context,
  }) async {
    try {
      await _audioPlayer.stop();
      final fileName = getSoundFile(action: action, context: context);
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      _isActive = false;
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playInLoop(BuildContext context) async {
    _isActive = true;
    for (var i = 0; i < 10; i++) {
      await playSound(action: i.toString(), context: context);
      if (!_isActive) break;
      await _audioPlayer.resume();
      await _audioPlayer.onPlayerComplete.first;
    }
  }

  void stopPlayback() {
    _isActive = false; // Dừng phát
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}