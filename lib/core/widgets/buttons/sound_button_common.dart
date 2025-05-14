import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundButton extends StatelessWidget {
  final String soundFile;
  final Function()? onPressed;
  final Widget child;

  SoundButton({super.key, required this.soundFile, required this.child, this.onPressed});

  // Khởi tạo AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Hàm phát âm thanh
  void playSound(String sound) async {
    await _audioPlayer.play(AssetSource('sounds/$sound'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          playSound(soundFile); // Phát âm thanh khi bấm nút
        } catch (e) {
          debugPrint(e.toString());
        }
        onPressed?.call();
      },
      child: child,
    );
  }
}