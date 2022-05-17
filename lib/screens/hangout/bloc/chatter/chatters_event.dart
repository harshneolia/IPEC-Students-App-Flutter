import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/repo/pings.dart';

class ChattersEvent extends BaseEvent {
  ChattersEvent([List props = const []]) : super(props);
}

class LoadChattersEvent extends ChattersEvent {
  final String? postID;
  final Pings pings;

  LoadChattersEvent(this.postID, this.pings);
}
