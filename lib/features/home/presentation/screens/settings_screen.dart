import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../core/core.dart';
import '../../../features.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SoundHelper soundHelper = SoundHelper();

  Future<void> onTapHandler(BuildContext context, SoundHelper soundHelper) async {
    soundHelper.playInLoop(context);
  }
  @override
  void dispose() {
    soundHelper.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = Modular.get<AppCubit>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.numberType),
            trailing: const FontSelector(),
          ),
          BlocBuilder<AppCubit, AppState>(
            bloc: appCubit,
            builder: (context, state) {
              return ListTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: DropdownButton<LanguageEnum>(
                  value: state.currentLanguage,
                  items: LanguageEnum.values.map((language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(language.displayName),
                    );
                  }).toList(),
                  onChanged: (LanguageEnum? newLanguage) {
                    if (newLanguage != null) {
                      appCubit.changeLanguage(newLanguage);
                    }
                  },
                ),
              );
            },
          ),
          BlocBuilder<AppCubit, AppState>(
            bloc: appCubit,
            builder: (context, state) {
              return ListTile(
                title: Text(AppLocalizations.of(context)!.soundKeyboard),
                trailing: DropdownButton<VoiceEnum>(
                  value: state.sound,
                  items: VoiceEnum.values.map((sound) {
                    return DropdownMenuItem(
                      value: sound,
                      child: Text(sound.localized(AppLocalizations.of(context)!)),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      soundHelper.stopPlayback();
                      appCubit.changeSound(value);
                      await onTapHandler(context, soundHelper);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
