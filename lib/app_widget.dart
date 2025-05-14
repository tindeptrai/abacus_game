import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/features.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = Modular.get<AppCubit>();
    return BlocBuilder<AppCubit, AppState>(
      bloc: appCubit,
      builder: (context, state) {
        return MaterialApp.router(
          title: 'SoFi Su-Ru Games',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('vi'), // Vietnamese
            Locale('ja'), // Japanese
          ],
          locale: state.currentLanguage.locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: state.fontModel.name,
          ),
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}
