import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../presentation.dart';

class AbacusSettingsScreen extends StatefulWidget {
  final AbacusSettingsCubit cubit;
 const AbacusSettingsScreen(this.cubit, {super.key});
  @override
  State<AbacusSettingsScreen> createState() => _AbacusSettingsScreenState();
}

class _AbacusSettingsScreenState extends BaseSettingScreenState<AbacusSettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'SoFiFunNumber',
      ),
      child: BlocBuilder<AbacusSettingsCubit, SettingGameState>(
        bloc: widget.cubit,
        builder: (context, state) {
          final isMulAndDi = state.isMultiOrDivision;
          final levelDisplay = !isMulAndDi
              ? "${state.level.level}"
              : "${state.level.level} - ${state.level.subLevel}";

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(titleAppBarText),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chọn Level
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          levelWidget(levelDisplay, state.isMultiOrDivision),
                          if (!isMulAndDi) ...[
                            const SizedBox(
                              height: 16,
                            ),
                            rangeWidget(state.rangeEnum),
                          ],
                          const SizedBox(
                            height: 16,
                          ),
                          operatorWidget(state.operator),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ButtonCommon(
                    onPressed: () async {
                      await widget.cubit.pushToAbacusGame();
                    },
                    label: localizations.start,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  String get titleAppBarText => "Abacus Settings";

  @override
  // TODO: implement cubit
  SettingGameCubit get cubit =>  widget.cubit;
}
