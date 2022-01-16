import 'package:flutter/material.dart';
import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/model/hangout/comment.dart';
import '../../data/repo/pings.dart';
import 'bloc/chatter/chatters_bloc.dart';
import 'widget/comment_widget.dart';
import '../../theme/style.dart';
import 'package:provider/provider.dart';
import 'bloc/chatter/chatters_event.dart';
import 'bloc/chatter/chatters_state.dart';

class Chatters extends StatefulWidget {
  final String? postID;
  final String? currentUserID;
  const Chatters({Key? key, required this.postID, required this.currentUserID})
      : super(key: key);

  @override
  _ChattersState createState() => _ChattersState();
}

class _ChattersState extends State<Chatters> {
  final _bloc = ChattersBloc(ChattersInitialState());

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Pings>(
      builder: (context, pings, child) {
        return BaseBlocListener(
          bloc: _bloc,
          listener: (BuildContext context, BaseState state) {
            print("$runtimeType BlocListener - ${state.toString()}");
          },
          child: BaseBlocBuilder(
            bloc: _bloc,
            condition: (BaseState previous, BaseState current) {
              return !(BaseBlocBuilder.isBaseState(current));
            },
            builder: (BuildContext context, BaseState state) {
              print("$runtimeType BlocBuilder - ${state.toString()}");

              if (state is ChattersInitialState)
                _bloc.add(LoadChattersEvent(widget.postID, pings));

              if (state is ChattersLoadingState)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              if (state is ChattersLoadedState)
                return _getBody(pings.comments[widget.postID]);
              return Container();
            },
          ),
        );
      },
    );
  }

  Widget _getBody(List<CommentModel>? comments) {
    if (comments == null || comments.length == 0)
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text("Be the first one to chatter 😊 "),
      );
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kMedPadding,
          Text(
            "Chatter",
            style: Theme.of(context).textTheme.headline6,
          ),
          kMedPadding,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              if (comments[index].reports! > 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'A comment has been removed due to many reports',
                    textAlign: TextAlign.center,
                  ),
                );
              } else
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CommentWidget(
                    commentModel: comments[index],
                    currentUserID: widget.currentUserID,
                    postID: widget.postID,
                  ),
                );
            },
          ),
        ],
      );
  }
}
