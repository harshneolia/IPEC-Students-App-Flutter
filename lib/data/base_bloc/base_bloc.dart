import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'base_event.dart';
import 'base_state.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<BaseEvent, BaseState> {
  BaseBloc(BaseState initialState) : super(initialState);

  get initialState => initialState;

  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    print(">>>>>>>>>>>>> BaseBloc Event ${event.toString()}");

    if (event is ShowSnackBarErrorEvent) {
      yield ShowSnackBarErrorState(event.error);
    }

    if (event is PlaceHolderEvent) {
      yield PlaceHolderState();
    }

    if (event is ShowDialogInfoEvent) {
      yield ShowDialogInfoState(event.title, event.message);
    }

    if (event is ShowDialogErrorEvent) {
      yield ShowDialogErrorState(event.error);
    }

    if (event is InitStateEvent) {
      yield InitState();
    }

    if (event is LogoutEvent) {
      yield LogoutState();
    }

    yield* mapBaseEventToBaseState(event as E);
  }

  Stream<S> mapBaseEventToBaseState(E event);

  bool resetToInitStateOnError() => false;

  @override
  void onError(Object error, StackTrace stackTrace) {
    print("On Error");
    print(error.toString());
    print(stackTrace.toString());

    if (resetToInitStateOnError()) {
      add(InitStateEvent());
    }

    if (error is DioError) {
      errorHandlerEvent(error);
    } else {
      String? errorMessage;
      if (error is PlatformException) {
        errorMessage = error.message;
      }

      add(ShowDialogErrorEvent(errorMessage ?? error.toString()));
    }
    super.onError(error, stackTrace);
  }

  void errorHandlerEvent(DioError error) {
    if (error.type == DioErrorType.response) {
      add(ShowDialogErrorEvent(
          "Something went wrong : " + error.message.toString()));
    }

    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.sendTimeout) {
      add(ShowDialogErrorEvent(
          "Connection Time Out : " + error.message.toString()));
    }
    if (error.type == DioErrorType.other) {
      add(ShowDialogErrorEvent(
          "Something went wrong : " + error.message.toString()));
    }
  }
}

class DataRepo {}
