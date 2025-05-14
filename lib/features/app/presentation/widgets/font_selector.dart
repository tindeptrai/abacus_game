import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../cubit/app_cubit.dart';

class FontSelector extends StatelessWidget {
  const FontSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      bloc: Modular.get<AppCubit>(),
      builder: (context, state) {
        return DropdownButton<FontFamilyEnum>(
          value: state.fontModel,
          items: FontFamilyEnum.values.map<DropdownMenuItem<FontFamilyEnum>>((FontFamilyEnum value) {
            return DropdownMenuItem<FontFamilyEnum>(
              value: value,
              child: Text(value.getLocalizedName(context)),
            );
          }).toList(),
          onChanged: (FontFamilyEnum? newValue) {
            if (newValue != null) {
              Modular.get<AppCubit>().changeFont(newValue);
            }
          },
        );
      },
    );
  }
}

enum FontFamilyEnum {
  roboto('Roboto'),
  sofiFunNumber('SoFiFunNumber');

  final String fontFamily;
  
  const FontFamilyEnum(this.fontFamily);

  String getLocalizedName(BuildContext context) {
    switch (this) {
      case FontFamilyEnum.roboto:
        return AppLocalizations.of(context)!.oldNumber;
      case FontFamilyEnum.sofiFunNumber:
        return AppLocalizations.of(context)!.newNumber;
    }
  }
} 
