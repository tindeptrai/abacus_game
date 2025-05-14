import 'package:flutter/material.dart';

import '../../core.dart';

abstract class BaseSofiFunState<W extends StatefulWidget, B extends BaseSofiFunCubit> extends State<W> {

  B get cubit;
  BuildContext get getContext => context;

}