import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'topic_details_viewmodel.g.dart';

abstract class TopicDetailsViewModel
    implements Built<TopicDetailsViewModel, TopicDetailsViewModelBuilder> {
  String get name;

  String get description;

  ChannelVisibility get visibility;

  BuiltList<User> get members;

  String get groupId;

  Channel get channel;

  String get userId;

  TopicDetailsViewModel._();

  factory TopicDetailsViewModel(
          [void Function(TopicDetailsViewModelBuilder) updates]) =
      _$TopicDetailsViewModel;

  static TopicDetailsViewModel fromStore(Store<AppState> store) {
    final channel = getSelectedChannel(store.state);
    final members = store.state.groupUsers
        .where((user) => channel.users.any((u) => u.id == user.uid));

    return TopicDetailsViewModel((t) => t
      ..name = channel.name
      ..visibility = channel.visibility
      ..description = channel.description ?? ""
      ..members.addAll(members)
      ..groupId = store.state.selectedGroupId
      ..channel = channel.toBuilder()
      ..userId = store.state.user.uid);
  }
}
