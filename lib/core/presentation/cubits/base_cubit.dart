import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseSofiFunCubit<T> extends Cubit<T>{
  BaseSofiFunCubit(super.initialState);

  // void showError(RestException err){
  //   emitListener(err.errorResponse?.errorMessage);
  // }
  //
  // void showMessage(String mess){
  //   emitListener(mess);
  // }
}