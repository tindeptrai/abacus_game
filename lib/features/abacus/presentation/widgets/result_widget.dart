import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';

class ResultPopup extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String userAnswer;
  final String responseTime;
  final String level;
  final double speed;
  final int? quantityHeart;
  final bool? showSpeed;

  const ResultPopup({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    this.userAnswer = '',
    this.responseTime = '',
    required this.level,
    required this.speed,
    this.quantityHeart,
    this.showSpeed = true,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect
                          ? '${localization.correct}!'
                          : '${localization.incorrect}!',
                      style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SoFiFunNumber'),
                    ),
                    const SizedBox(height: 10),
                    if (isCorrect)
                      FittedBox(
                        child: Text(
                          '${localization.you_got_reward} $quantityHeart ⭐',
                          style: const TextStyle(
                            fontFamily: 'SoFiFunNumber',
                            fontSize: 24,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      '${localization.answer}: $correctAnswer',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'SoFiFunNumber',
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!isCorrect) ...[
                      Text(
                        '${localization.your_answer}: $userAnswer',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'SoFiFunNumber',
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      '${localization.response_time}: $responseTime s',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'SoFiFunNumber',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${localization.level}: $level',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'SoFiFunNumber',
                      ),
                    ),
                    if (showSpeed ?? true) ...[
                      const SizedBox(height: 10),
                      Text(
                        '${localization.speed}: $speed s',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'SoFiFunNumber',
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ButtonCommon(
              backgroundColor: Colors.white,
              border: const BorderSide(width: 1, color: Colors.green),
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'SoFiFunNumber',
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              label: localization.stop_playing,
            ),
            const SizedBox(
              height: 6,
            ),
            ButtonCommon(
              actionSound: 'Do',
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SoFiFunNumber',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              label: localization.continue_playing,
            ),
          ],
        ),
      ),
    );
  }
}
