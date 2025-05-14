import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../modular/route.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../features.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = Modular.get<HomeCubit>()..getLastPlayer();
    final translations = AppLocalizations.of(context);
    if (translations == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Loading(
      loadingStream: homeCubit.loadingStream,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            translations.appTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              onPressed: () {
                Modular.to.pushNamed(AppRouteConstants.settingsFullRoute);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: BlocListener<HomeCubit, HomeState>(
          bloc: homeCubit,
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_icon/logo_1024.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 12,
                ),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                    child: BlocBuilder<HomeCubit, HomeState>(
                      bloc: homeCubit,
                      builder: (context, state) {
                        if (state.lastPlayer != null) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.lastPlayer!.name,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(translations.warning),
                                            content: Text(translations.confirmChangeName),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(translations.cancel),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  homeCubit.clearPlayer();
                                                  Navigator.pop(context);
                                                },
                                                child: Text(translations.confirm),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      translations.newName,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    child: Text(
                                      translations.welcomeToGame,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text(
                                translations.chooseGame,
                                style: TextStyle(fontSize: 18, color: Colors.indigo[700], fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ButtonCommon(
                                    actionSound: 'SoFiAbacusGame',
                                    label: translations.sofiAbacusGame,
                                    onPressed: () async {
                                      Modular.to.pushNamed(
                                        AppRouteConstants.abacusRoute,
                                        arguments: MathArg(
                                          player: state.lastPlayer!,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ],
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: homeCubit.nameController,
                              decoration: InputDecoration(
                                labelText: translations.playerName,
                                labelStyle: const TextStyle(color: Colors.indigo),
                                hintText: translations.enterPlayerName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.indigo, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (state.hasCurrentPlayer) ...[
                                  Expanded(
                                    child: ButtonCommon(
                                      label: translations.back,
                                      onPressed: () async {
                                        if (context.mounted) {
                                          homeCubit.getLastPlayer();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Expanded(
                                  child: ButtonCommon(
                                    label: translations.start,
                                    onPressed: () async {
                                      if (await homeCubit.savePlayer()) {
                                        if (context.mounted) {
                                          homeCubit.getLastPlayer();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
