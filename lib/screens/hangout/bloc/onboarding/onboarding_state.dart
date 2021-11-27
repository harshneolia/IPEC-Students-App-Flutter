import '../../../../data/base_bloc/base_state.dart';
import '../../../../data/model/hangout/hangUser.dart';

class OnboardingState extends BaseState {
  OnboardingState([List props = const []]) : super(props);
}

class OnboardingInitState extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingFailed extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final Huser user;

  OnboardingLoaded(this.user);
}

class SavedUserState extends OnboardingState {
  final Huser user;

  SavedUserState(this.user);
}
