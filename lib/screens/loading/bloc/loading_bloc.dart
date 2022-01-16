import '../../../data/base_bloc/base_bloc.dart';
import '../../../data/base_bloc/base_event.dart';
import '../../../data/base_bloc/base_state.dart';
import '../../../data/local/shared_pref.dart';
import '../../../data/model/GeneralResponse.dart';
import '../../../util/SugarParse.dart';
import 'loading_event.dart';
import 'loading_state.dart';

class LoadingBloc extends BaseBloc {
  LoadingBloc(BaseState initialState) : super(initialState);

  @override
  BaseState get initialState => LoadingInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    LocalData _localData = LocalData();
    if (event is ResetState) yield LoadingInitState();

    if (event is CheckCredentials) {
      try {
        GeneralResponse response = await event.auth
            .login(event.auth.cred!.username!, event.auth.cred!.password);
        if (response.status) {
          event.auth.user =
              SugarParser().user(response.data.data, event.auth.cred!.username);

          await _localData.saveUserPreference(
              event.auth.cred!.username!,
              event.auth.cred!.password!,
              event.auth.user!.name!,
              event.auth.user!.img);
          await Future.delayed(Duration(milliseconds: 50));
          yield AuthenticatedState();
        } else {
          // Invalid Cred probably so trying again
          await Future.delayed(Duration(seconds: 1));
          GeneralResponse response = await event.auth
              .login(event.auth.cred!.username!, event.auth.cred!.password);
          if (response.status) {
            event.auth.user = SugarParser()
                .user(response.data.data, event.auth.cred!.username);

            await _localData.saveUserPreference(
                event.auth.cred!.username!,
                event.auth.cred!.password!,
                event.auth.user!.name!,
                event.auth.user!.img);
            await Future.delayed(Duration(milliseconds: 50));
            yield AuthenticatedState();
          } else {
            // Invalid Cred confirm
            yield LoginFailState();
            await Future.delayed(Duration(seconds: 2));
            yield CloseLoadingState();
          }
          // yield LoginFailState();
          // await Future.delayed(Duration(seconds: 2));
          // yield CloseLoadingState();
        }
      } on Exception catch (e) {
        yield ShowDialogErrorState(e.toString());
        yield CloseLoadingState();
      }
    }
  }
}
