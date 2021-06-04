import 'package:ipecstudentsapp/data/model/hangout/hangUser.dart';

import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/model/User.dart';

class HangoutEvent extends BaseEvent {
  HangoutEvent([List props = const []]) : super(props);
}

class LoadPingsEvent extends HangoutEvent {}

class OnboardFinishEvent extends HangoutEvent {
  final Huser huser;

  OnboardFinishEvent(this.huser);
}

class CheckUserEvent extends HangoutEvent {
  final User user;

  CheckUserEvent(this.user);
}